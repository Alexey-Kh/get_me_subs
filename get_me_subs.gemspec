# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "get_me_subs"
  spec.version       = '1.0'
  spec.author        = "Alexey Kharkin"
  spec.email         = ["alexey.kharkin@gmail.com"]
  spec.summary       = %q{ Downloads subtitles for serials. }
  spec.description   = %q{ Downloads subtitles for serials. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = ['lib/get_me_subs.rb']
  spec.executables   = ['bin/get_me_subs']
  spec.test_files    = ['tests/test_get_me_subs.rb']
  spec.require_paths = ["lib"]
end