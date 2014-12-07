module GetMeSubs
  class Sub
    module Downloader

      # Download file
      def self.download_file(uri, save_to)
        File.open(save_to, "wb") do |saved_file|
          open(uri, "rb") do |read_file|
            saved_file.write(read_file.read)
          end
        end
      end

    end
  end
end