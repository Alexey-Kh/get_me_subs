require "./lib/getmesubs.rb"

Shoes.app title: 'GetMeSubs', width: 400, height: 300 do
  background black

  flow margin: [0, 20, 0, 10] do 
    stack width: 0.7, margin: [10, 0, 0, 0] do
      para("Enter file name", stroke: white, size: 'xx-small')
      @input_file_name = edit_line(width: 1.0)
    end
    stack width: 0.25, margin: [10, 0, 10, 0] do
      para("Language", stroke: white, size: 'xx-small', align: 'center')
      @input_language = list_box( width: 1.0, items: ['English'], choose: "English")
    end
  end
 
  stack do
    para "Choose save path", stroke: white, margin: 10, size: 'xx-small'
    flow do
      stack width: 0.7, margin: [10, 0, 0, 0] do
        @input_address = edit_line(width: 1.0)
        @input_address.change {|l| @save_address = l.text}
      end
      stack width: 0.25, margin: [10, 0, 10, 0] do
        @but_choose_address = button('Browse...', width: 1.0)
      end
      
      @but_choose_address.click do
        @save_address = ask_save_folder
        @input_address.text = @save_address
      end
    end
  end

  stack margin: [0.33, 50, 0.33, 0] do
    @but_download = button("Download", width: 1.0)
  end

  para("Copyright (c) 2014 Alexey Kharkin", align: 'center', size: 7, stroke: white, margin: [0, 40, 0, 0])

  @but_download.click do |b|
    if @save_address == nil
      alert("Choose save path!")
    else
      @file_name = @input_file_name.text
      #@para_file_name.replace("Current file name: '#{@file_name}'", stroke: white, hidden: false)
      begin
        GetMeSubs.get(@file_name, @save_address)
        alert('Done!')
      rescue GetMeSubs::GetMeSubsError => e
        alert(e.message)
      rescue Exception => e
        alert(e.message)
      end
    end
  end  
  
end