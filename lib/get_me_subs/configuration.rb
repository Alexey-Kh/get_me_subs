module GetMeSubs
  class Configuration

    attr_reader :settings

    # Defines os and config file path, then reads config
    def initialize
      define_os
      define_path
      read_settings
    end

    # Sets new settings
    def set_settings(settings)
      @settings.merge!(settings)
    end

    # Saves settings into yaml file
    def save_settings
      File.open(@path, "w") do |file|
        file.write @settings.to_yaml
      end
    end

    private 

      # Defines user's OS and sets instanse variable with this information.
      # Raises error if unknown OS
      def define_os
        @os ||= (
          host_os = RbConfig::CONFIG['host_os']
          case host_os
          when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
            :windows
          when /darwin|mac os/
            :macosx
          when /linux/
            :linux
          when /solaris|bsd/
            :unix
          else
            raise GetMeSubsError.new("Unknown os: #{host_os.inspect}")
          end
        )
      end

      # Defines config file path and sets instanse variable with this info.
      # Creates folders if necessary.
      # Raises error if unsupported OS
      def define_path
        raise GetMeSubsError.new("Settings for this OS aren't supported.") if @os != :windows
        @path = (
          case @os
          when :windows
            ENV['APPDATA'] + "/GetMeSubs/settings.yaml"
          end
        )
        FileUtils.mkdir_p(File.dirname(@path))
      end

      # Reads yaml config file and sets instance variable according to got data. Sets empty hash if file is empty
      def read_settings
        begin
          @settings = YAML::load_file(@path)
        rescue
          @settings = {}
        end
      end
    
  end
end