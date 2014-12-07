module GetMeSubs
  module Validator

    # Check if save_folder is valid
    def self.validate_save_path(save_folder)
      raise GetMeSubsError.new("Save path not found.") unless File.directory?(save_folder)
      save_folder
    end

  end
end