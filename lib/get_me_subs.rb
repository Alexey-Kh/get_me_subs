require 'open-uri'
require 'ordinal_word'
require 'yaml'
require 'rbconfig'
require 'fileutils'

require_relative './get_me_subs/configuration.rb'
require_relative './get_me_subs/validator.rb'
require_relative './get_me_subs/sub.rb'
require_relative './get_me_subs/sub/downloader.rb'
require_relative './get_me_subs/sub/parser.rb'
# TODO
# + add simple GUI 
# + add simple input
# + add save address input
# + add config file support (only Windows)
# + add 'download another subs' option
# - add config support of Linux, Mac OS
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
    # lib/get_me_subs/sub.rb
  end

  class Configuration
    # lib/get_me_subs/configuration.rb
  end

  module Validator
    # lib/get_me_subs/validator.rb
  end

  def self.get(name, settings = {})

    conf = Configuration.new
    conf.set_settings(settings)
    settings = conf.settings
    sub = Sub.new(settings)
    sub.parse_file_name(name)
    uris = sub.generate_uris_with_all_subs
    sub.check_uri_and_get_content(uris)
    predownload_link = sub.get_link
    download_link = sub.get_download_uri(predownload_link)
    sub.download_file(download_link)
    sub

  end

end

sub = GetMeSubs.get(gets.chomp, { save_folder: 'C:\Users\Irbis\Desktop\test' })
sub.another_sub


