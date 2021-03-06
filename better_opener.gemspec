# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "better_opener/version"

Gem::Specification.new do |s|
  s.name        = "better_opener"
  s.version     = BetterOpener::VERSION
  s.authors     = ["Kai Rubarth"]
  s.email       = ["kai@doxter.de"]
  s.homepage    = "https://github.com/learnjin/better-opener"
  s.summary     = %q{A better way of Previewing mail in your browser instead of sending it.}
  s.description = %q{When mails or messages are sent from your application, Better Opener lets you preview the rendered messages in your browser instead of delivering them.}

  s.rubyforge_project = "better_opener"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "sinatra-contrib"

  s.add_dependency "data_mapper", ">= 1.2"
  s.add_dependency "dm-sqlite-adapter"
  s.add_dependency "tilt"
  s.add_dependency "haml"
  s.add_dependency "multi_json"
end



