require 'open-uri'
require 'ordinal_word'

# TODO
# + add simple GUI 
# + add simple input
# + add save address input
# - add default save address/remind last save address
# - add 'download another subs' option
# - add codec, quality validation / get video info from file
# - add check before donwload if file extension is not .rar
# - add auto unrar feature
# - add multifile download option
# - get file name from path to the file
# - rename subs file to the #{file_name}.srt

module GetMeSubs

  class GetMeSubsError < Exception
  end

  class Sub

    attr_reader :language, :name, :season, :episode, :resolution

    def initialize
      @language = 'english'
      @site = 'http://subscene.com'
    end

    # Get file name from the user, get rid of unrequired elements, define name,
    # season, episode, resolution, codec if there is any
    def parse_file_name(name)

      regex = /^(?<name> (?: \W* \w+ \W* )+? )
              [^a-zA-Z]*  
              S (?<season> \d{2} )
              [^a-zA-Z]* 
              E (?<episode> \d{2} )
              /ix

      matches = regex.match(name.downcase)
      if (  matches == nil || matches['name'] == nil ||
            matches['season'] == nil || matches['episode'] == nil )
        raise GetMeSubsError.new("Failed to recognize name, season or episode of serial.")
      end
      @name = matches['name'].gsub(/[^a-zA-Z]+/, ' ').strip   # example: 'the flash'
      @season = matches['season']                             # example: '01'
      @episode = matches['episode']                           # example: '03'
      
      begin
        @resolution = /(360p | 480p | 720p | 1080p)/ix.match(name)[1]
      rescue
        @resolution = nil
      end

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
          open(uri, 'rb') { |f| return uri, f.read}
        rescue OpenURI::HTTPError
          next
        end
      end
      raise GetMeSubsError.new("Link validation has failed.") 

    end

    # Read web page, find all suitable links, push them to array of arrays [[link, name_of_the_link], ...]
    # Raise error if array is empty 
    def get_all_links(uri, page_content)

      rel_path = uri.gsub(%r{http://subscene.com}, '')
      name = @name.gsub(' ', ' [^a-z]+ ')

      # Regex for reading web page and finding all links with appropriate #{name}, #{season} and #{episode}

      regex = /<a .*? href=["'] ( #{rel_path} \/ \d+)["']>                 # relative path
               .*? 
               ( #{name} [^a-z]+ S #{@season} [^a-z]* E #{@episode} .*? )  # name
                \s* < /xim

      links_with_names = page_content.scan(regex)
      raise GetMeSubsError.new("Subtitles not found.") if links_with_names.empty?
      links_with_names

    end

    # Iterate through the array, returns first suitable link
    # Look at :resolution, :codec, etc
    def get_link(links_with_names)

      # Add @site in order to make absolute path
      return @site + links_with_names[0][0] if @resolution == nil
      links_with_names.each do | arr |
        return @site + arr[0] if arr[1] =~ /#{@resolution}/i
      end
      # If no matches
      return @site + links_with_names[0][0]

    end

    # Read web page with best subs and find "download" link
    def find_download_uri(uri)

      web_page = open(uri, "rb") { |f| f.read }
      res = web_page.scan(/ ["'] ( \/subtitle\/download .*? ) ["'] /ix)
      raise GetMeSubsError.new("Download link not found.") if res.empty?
      # Add @site in order to make absolute path
      @site + res[0][0]

    end

    # Download subs
    def download_file(uri, save_folder)
      # @save_folder = "C:/Users/Irbis/Desktop/#{@name}.s#{@season}e#{@episode}.GetMeSubs.#{rand(100)}.rar"
      save_to = save_folder + "/#{@name}.s#{@season}e#{@episode}.GetMeSubs.#{rand(100)}.rar"
      File.open(save_to, "wb") do |saved_file|
        open(uri, "rb") do |read_file|
          saved_file.write(read_file.read)
        end
      end

    end

    def validate_save_path(save_folder)
      raise GetMeSubsError.new("Save path not found.") unless File.directory?(save_folder)
      true
    end

  end

  def self.get(name, save_folder)

    sub = Sub.new
    sub.validate_save_path(save_folder)
    sub.parse_file_name(name)
    uris = sub.generate_uris_with_all_subs
    uri_with_all_subs, page_content = sub.check_uri_and_get_content(uris)
    links_with_names = sub.get_all_links(uri_with_all_subs, page_content)
    predownload_link = sub.get_link(links_with_names)
    download_link = sub.find_download_uri(predownload_link)
    sub.download_file(download_link, save_folder)
    sub

  end

end

# GetMeSubs.get(gets.chomp, 'C:\Users\Irbis\Desktop')

