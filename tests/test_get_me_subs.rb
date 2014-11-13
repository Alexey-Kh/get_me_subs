require "./lib/get_me_subs.rb"
require "minitest/autorun"

class TestNAME < MiniTest::Test
  
  def test_parse_file_name

    f = GetMeSubs::Sub.new
    f.parse_file_name(' The.Flash.S01_E02.1080p.rus.LostFilm.TV')
    assert_equal('the flash', f.name)
    assert_equal('01', f.season)
    assert_equal('02', f.episode)
    assert_equal('1080p', f.resolution)

    string = '
              The.Flash.S01_E02.480p.rus.LostFilm.TV

              The.Flas23.S01_E02.1080p.rus.LostFilm.TV


              The.Flashfgh.S01_E02.480p.rus.LostFilm.TV'
    f = GetMeSubs::Sub.new
    f.parse_file_name(string)
    assert_equal('the flash', f.name)
    assert_equal('01', f.season)
    assert_equal('02', f.episode)
    assert_equal('480p', f.resolution)

    f = GetMeSubs::Sub.new
    f.parse_file_name('The.Flash.s01e01.HD720p.WEB-DL.Rus.Eng.BaibaKo.tv')
    assert_equal('720p', f.resolution)
    

  end


  def test_generate_uris_with_all_subs

    f = GetMeSubs::Sub.new
    f.parse_file_name(' Arrow.S03E01.rus.LostFilm.TV')
    assert_equal(['http://subscene.com/subtitles/arrow-third-season/english',
                  'http://subscene.com/subtitles/arrow--third-season/english'], f.generate_uris_with_all_subs)

  end

  def test_check_uri_and_get_content

    uris = ['http://subscene.com/subtitles/arrow-third-season/english',
            'http://subscene.com/subtitles/arrow--third-season/english']
    uri, content = GetMeSubs::Sub.new.check_uri_and_get_content(uris)
    assert_equal('http://subscene.com/subtitles/arrow-third-season/english', uri)

    uris = ['http://subscene.com/subtitles/supernatural-twentieth-season/english',
            'http://subscene.com/subtitles/supernatural--twentieth-season/english']
    assert_raises(GetMeSubs::GetMeSubsError) { GetMeSubs::Sub.new.check_uri_and_get_content(uris) }

  end

  def test_get_all_links

    uri = 'http://subscene.com/subtitles/the-flash-first-season/english'
    page_content = %(END
        <td class="a1">
          <a href="/subtitles/the-flash-first-season/english/939309">
            <span class="l r positive-icon">
              English
            </span>
            <span>
              The.Flash.2014.S01E01.PREAIR.720p.WEB-DL.x264-NOGRP  
            </span>
          </a>
        </td>
        <td class="a3">
          1
        </td>
        <td class="a40">
          &nbsp;
        </td>
        <td class="a5">

        <a href="/u/724626">
          GoldenBeard
        </a>
        </td>
        <td class="a6">
          <div>
      Hade from scratch by chamallow...&nbsp;       </div>
        </td>
      </tr>

      <tr>
        <td class="a1">
          <a href="/subtitles/the-flash-first-season/english/939308">The.Flash.2014.S01E01.Pilot.PREAir.720p.WEB-DL.x264-NoGRP</a>
          <a href="/subtitles/the-flash-first-season/english/939308">The.Flash.2014.S01E03.Pilot.PREAir.720p.WEB-DL.x264-NoGRP</a>%)

    f = GetMeSubs::Sub.new
    f.parse_file_name('The.Flash.2014.S01E01.PREAIR.720p')
    links_with_names = f.get_all_links(uri, page_content)
    assert_equal([
                  ['/subtitles/the-flash-first-season/english/939309', 'The.Flash.2014.S01E01.PREAIR.720p.WEB-DL.x264-NOGRP'],
                  ['/subtitles/the-flash-first-season/english/939308', 'The.Flash.2014.S01E01.Pilot.PREAir.720p.WEB-DL.x264-NoGRP']
                 ], links_with_names)

    uri = 'http://subscene.com/subtitles/the-flash-first-season/english'
    page_content = %(<a href="/subtitles/the-fla-first-season/english/939308">The.Flash.2014.S01E03.Pilot.PREAir.720p.WEB-DL.x264-NoGRP</a>)
    f = GetMeSubs::Sub.new
    f.parse_file_name('The.Flash.2014.S01E01.PREAIR.720p')
    assert_raises(GetMeSubs::GetMeSubsError) {f.get_all_links(uri, page_content)}

  end

  def test_get_link

    links_with_names =[['/subtitles/the-flash-first-season/english/939309', 'The.Flash.2014.S01E01.PREAIR.720p.WEB-DL.x264-NOGRP'],
                      ['/subtitles/the-flash-first-season/english/939308', 'The.Flash.2014.S01E01.Pilot.PREAir.1080p.WEB-DL.x264-NoGRP']]
    f = GetMeSubs::Sub.new
    f.parse_file_name(' The.Flash.S01_E02.1080p.rus.LostFilm.TV')
    assert_equal('http://subscene.com/subtitles/the-flash-first-season/english/939308', f.get_link(links_with_names))

    links_with_names =[['/as', 3],
                      ['/subtitles/the-big-bang-theory-seventh-season/english/877925',
                        'The.Big.Bang.Theory.S07E18.720p.HDTV.x264-LOL']]
    f = GetMeSubs::Sub.new
    f.parse_file_name('The-Big  Bang*Theory.S07_-+E18.480p.WEB-DL.x264-mRS')
    assert_equal('http://subscene.com/as', f.get_link(links_with_names))

    f = GetMeSubs::Sub.new
    f.parse_file_name('The-Big  Bang*Theory.S07_-+E18.WEB-DL.x264-mRS')
    assert_equal('http://subscene.com/as', f.get_link(links_with_names))

  end

  def test_find_download_uri

    uri = 'http://subscene.com/subtitles/the-big-bang-theory-seventh-season'
    f = GetMeSubs::Sub.new
    assert_raises(GetMeSubs::GetMeSubsError) { f.find_download_uri(uri) }

  end

end