module GetMeSubs
  class Sub
    module Parser

      # Parse file name and return hash with name, season and episode
      def self.parse_file_name(name)
        regex = /^(?<name> (?: \W* \w+ \W* )+? )
                [^a-zA-Z]*  
                S (?<season> \d{2} )
                [^a-zA-Z]* 
                E (?<episode> \d{2} )
                /ix

        regex.match(name.downcase)
      end

      # Read web page, find suitable link, return array with link and its name
      def self.parse_all_links(uri, page_content, name, season, episode, offset)

        rel_path = uri.gsub(%r{http://subscene.com}, '')
        edited_name = name.gsub(' ', ' [^a-z\n]+ ')

        # Regex for reading web page and finding links with appropriate #{name}, #{season} and #{episode}

        regex = /<a \  href=["'] ( #{rel_path} \/ \d+)["']>                 # relative path
                 (?: .(?! a>))*?
                 ( #{edited_name} [^\n]+ S #{season} [^a-z]* E #{episode} .*? )  # name
                  (?<= \/)a(?= >) /xim

        match = page_content.match(regex, offset)
        raise GetMeSubsError.new("Download link not found.") if !match
        index = Regexp.last_match.begin(2)
        return match, index

      end

      # Read web page and find "download" link
      def self.parse_download_page(download_page)
        download_page.match(/ ["'] ( \/subtitle\/download .*? ) ["'] /ix)
      end

    end
  end
end