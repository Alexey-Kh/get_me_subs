require_relative "./get_me_subs.rb"

Shoes.app title: 'GetMeSubs', width: 400, height: 300 do
  background white

  flow margin: [0, 20, 0, 10] do 

    stack width: 0.7, margin: [10, 0, 0, 0] do
      para("Enter file name", size: 'xx-small')
      @input_file_name = edit_line(width: 1.0)

      @input_file_name.change do |l|
        if @but_download == nil
          @buttons.append do
            @but_download = button("Download", width: 1.0) { @but_download_proc.call }
            @but_download_another.remove
            @but_download_another = nil
          end
        end
      end

    end

    stack width: 0.25, margin: [10, 0, 10, 0] do
      para("Language", size: 'xx-small', align: 'center')
      @input_language = list_box( width: 1.0, items: ['English'], choose: "English")
    end

  end

  
  stack do
    para "Choose save path", margin: 10, size: 'xx-small'
    flow do
      stack width: 0.7, margin: [10, 0, 0, 0] do
        @input_address = edit_line(width: 1.0)
        settings = GetMeSubs::Configuration.new.settings
        if settings.has_key?(:save_folder)
          @save_address = @input_address.text = settings[:save_folder]
        end
        @input_address.change do |l| 
          @save_address = l.text
          if @but_download == nil
            @buttons.append do
              @but_download = button("Download", width: 1.0) { @but_download_proc.call }
              @but_download_another.remove
              @but_download_another = nil
            end
          end
        end
      end
      stack width: 0.25, margin: [10, 0, 10, 0] do
        @but_choose_address = button('Browse...', width: 1.0)
      end
      
      @but_choose_address.click do
        @save_address = ask_save_folder
        @input_address.text = @save_address
      end
    end
    flow margin: [10, 5, 0, 10] do
      @save_folder_check = check
      para "Save path as default", size: 'xx-small', margin: [0, 2, 0, 0]
    end
  end

  @buttons = stack margin: [0.33, 20, 0.33, 0] do
    @but_download_proc = Proc.new do
      if @save_address == nil
        alert("Choose save path!")
      else
        @file_name = @input_file_name.text
        begin
          @get = GetMeSubs.get(@file_name, { save_folder: @save_address })
          if @save_folder_check.checked?
            conf = GetMeSubs::Configuration.new
            conf.set_settings({ save_folder: @save_address })
            conf.save_settings
          end
          alert('Done!')
          @buttons.append do
            @but_download_another = button("Download Another", width: 1.0) do
              begin 
                @get.another_sub
                alert('Done!')
              rescue GetMeSubs::GetMeSubsError => e
                alert(e.message)
              rescue Exception => e
                alert(e.message)
              end
            end
            @but_download.remove
            @but_download = nil
          end
        rescue GetMeSubs::GetMeSubsError => e
          alert(e.message)
        rescue Exception => e
          alert(e.message)
        end
      end
    end

    @but_download = button("Download", width: 1.0) { @but_download_proc.call }

  end

  para("Copyright (c) 2014 Alexey Kharkin", align: 'center', size: 7, margin: [0, 30, 0, 0])
  
end