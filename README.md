# get_me_subs

GetMeSubs is a small program written in Ruby, that downloads subtitles for serials.

## Graphical user interface (GUI)

Current version uses [Shoes](http://shoesrb.com) for providing GUI.

## Language of subtitles:

Current version supports only English.

## Compilation

The program can be compiled using [Shoes](http://shoesrb.com). Already compiled executable first version for Windows can be downloaded [here](https://drive.google.com/file/d/0B4bk8lTUIGADbmpENEZWdjFWamc/view) (tested on Win 7 and Win XP). All required for work tools (Ruby, Shoes) are included in the executable file.

## Image

![GetMeSubs](http://s24.postimg.org/ylmuvbp9h/Get_Me_Subs.png)

## How it works:

* you should enter file name, choose save path and click "Download";
* program parses the name of the file, which should include name, number of season and episode, e.g. "Elementary.S03E02.WEBDL.720p.TV";
* wait for the archive with subtitles to be downloaded.

## Planned future features:

* ~~add simple GUI~~
* ~~add simple input~~
* ~~add save address input~~
* **refactor structure**
* **refactor tests**
* add default save address/remind last save address
* add 'download another subs' option
* add codec, quality validation / get video info from file
* add check before donwload if file extension is not .rar
* add auto unrar feature
* add multifile download option
* get file name from path to the file
* rename subs file to the #{file_name}.srt

## Dependencies

Uses [ordinal_word](https://github.com/Alexey-Kh/ordinal_word) Ruby gem.