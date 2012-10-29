require 'rubygems'
require 'rspec'
require 'nokogiri'

require './lib/nukumber'

# Monkey patch Nukumber to expose stuff for tests
module Nukumber
  class Cli
    attr_reader :runtime
  end
  class Runtime
    attr_reader :tests_passed, :tests_failed, :tests_pending, :tests_undefined, :reporter
  end
end
