# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require './lib/nukumber/version'

Gem::Specification.new do |s|

  s.name        = "nukumber"
  s.version     = Nukumber::VERSION
  s.summary     = "Run Gherkin feature files a bit more simply"
  s.description = "Specify your tests using Gherkin, but avoid the hassle of step definitions"
  s.homepage    = "https://github.com/ibsh/nukumber"
  s.author      = "Ibrahim Sha'ath"
  s.email       = "nukumber@ibrahimshaath.co.uk"

  s.files       = Dir['lib/**/*.rb', 'bin/*']
  s.executables << "nukumber"

  s.add_runtime_dependency "gherkin",  ">= 2.11.1"
  s.add_runtime_dependency "nokogiri", "~> 1.5"

  s.add_development_dependency "rake", ">= 0.9.2"

end
