# get_me_subs

GetMeSubs is a small program written in Ruby, that downloads subtitles for serials.
Current version is **2.0.0**.

## Graphical user interface (GUI)

Current version uses [Shoes](http://shoesrb.com) for providing GUI.

## Language of subtitles:

Current version supports only English.

## Compilation

The program can be compiled using [Shoes](http://shoesrb.com). Already compiled executable of **version 2.0.0** for Windows can be downloaded [here](https://drive.google.com/file/d/0B4bk8lTUIGADTndFYUpJWHVLM1k/view?usp=sharing) (tested on Win 7). All required for work tools (Ruby, Shoes) are included in the executable file.

Old version:
* [1.0.0](https://drive.google.com/file/d/0B4bk8lTUIGADbmpENEZWdjFWamc/view) (tested on Win 7 and Win XP)

## Image

![GetMeSubs](http://s30.postimg.org/jqvtu1z3l/Get_Me_Subs_v2_0_0.png)

## How it works:

* you should enter file name, choose save path and click "Download";
* program parses the name of the file, which should include name, number of season and episode, e.g. "Elementary.S03E02.WEBDL.720p.TV";
* wait for the archive with subtitles to be downloaded.

## Changes in version 2.0.0

Current version supports only Windows Os.

* refactored structure
* added configuration yaml file in user's home directory
* refactored parser: improved speed, fixed bugs
* added "Save default path" checkbox in GUI
* added "Download Another" sub feature
* some others

## Planned future features:

* ~~add simple GUI~~
* ~~add simple input~~
* ~~add save address input~~
* refactor structure (partially done)
* **refactor tests**
* ~~add default save address/remember last save address~~
* ~~add 'download another subs' option~~
* add support of Linux and Mac OS
* add codec, quality validation / get video info from file
* add check before donwload if file extension is not .rar
* add auto unrar feature
* add multifile download option
* get file name from path to the file
* rename subs file to the #{file_name}.srt

## Dependencies

Uses [ordinal_word](https://github.com/Alexey-Kh/ordinal_word) Ruby gem.