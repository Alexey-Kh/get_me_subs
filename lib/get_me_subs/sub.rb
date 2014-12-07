module GetMeSubs
  class Sub

    module Downloader
      # lib/get_me_subs/sub/downloader.rb
    end

    module Parser
      # lib/get_me_subs/sub/parser.rb
    end

    attr_reader :language, :name, :season, :episode

    def initialize(conf)
      @save_folder = Validator.validate_save_path(conf[:save_folder])
      @language = 'english'
      @site = 'http://subscene.com'
      # sets starting point for match in get_link method 
      @parse_all_links_offset = 0
      @downloader_counter = 0
    end

    # Get file name from the user, get rid of unrequired elements, define name,
    # season, episode, codec if there is any
    def parse_file_name(name)

      matches = Parser.parse_file_name(name)
      if (  !matches || matches['name'] == nil ||
            matches['season'] == nil || matches['episode'] == nil )
        raise GetMeSubsError.new("Failed to recognize name, season or episode of serial.")
      end
      @name = matches['name'].gsub(/[^a-zA-Z]+/, ' ').strip   # example: 'the flash'
      @season = matches['season']                             # example: '01'
      @episode = matches['episode']                           # example: '03'
      
    end

    # Make uri with all subs from the file name 
    def generate_uris_with_all_subs

      name_with_hyphens = @name.gsub(' ', '-')
      season_ordinal = OrdinalWord.wordinalize(@season.to_i)    # transform cardinal to ordinal in form of word
      uris = ["http://subscene.com/subtitles/#{name_with_hyphens}-#{season_ordinal}-season/#{@language}",
            "http://subscene.com/subtitles/#{name_with_hyphens}--#{season_ordinal}-season/#{@language}"]

    end

    # Return correct uri with all subs and the content of this web page
    # If incorrect uri raise error
    def check_uri_and_get_content(uris)

      uris.each do |uri|
        begin 
          open(uri, 'rb') do |f| 
            @uri_with_all_subs = uri
            @all_subs_page_content = f.read 
            return @uri_with_all_subs , @all_subs_page_content
          end
        rescue OpenURI::HTTPError
          next
        end
      end
      raise GetMeSubsError.new("Link validation has failed.") 

    end

    # Read web page, find suitable link using function from Parser module depending on site
    # Raise error if array is empty 
    def get_link

      link_with_name, @parse_all_links_offset = Parser.parse_all_links(@uri_with_all_subs, @all_subs_page_content, 
                                                                       @name, @season, @episode, @parse_all_links_offset)

      raise GetMeSubsError.new("Subtitles not found.") if !link_with_name
      # Add @site in order to make absolute path
      return @site + link_with_name[1]

    end

    # Read web page and find "download" link
    def get_download_uri(uri)

      download_page = open(uri, "rb") { |f| f.read }
      match = Parser.parse_download_page(download_page)
      # Add @site in order to make absolute path
      @site + match[1]

    end

    # Download subs
    def download_file(uri)
      @downloader_counter += 1
      save_to = @save_folder + "/#{@name}.s#{@season}e#{@episode}.GetMeSubs.#{@downloader_counter}.rar"
      Downloader.download_file(uri, save_to)
    end

    def another_sub
      predownload_link = get_link
      download_link = get_download_uri(predownload_link)
      download_file(download_link)
    end

  end
end