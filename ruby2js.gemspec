# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ruby2js/version"

Gem::Specification.new do |s|
  s.name        = "ruby2js"
  s.version     = Ruby2js::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Javier Toledo"]
  s.email       = ["javier@theagilemonkeys.com"]
  s.homepage    = "http://www.theagilemonkeys.com"
  s.summary     = %q{Ruby to JS compiler}
  s.description = %q{This is a gem intended to convert Ruby scripts into JavaScript code executable on any browser.}

  s.rubyforge_project = "ruby2js"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = %w(ruby2js)
  s.require_paths = ["lib"]
  
  s.add_dependency('ruby_parser', '>= 2.3.1')
end
