require 'spec_helper'

describe Nukumber::Reporter::Mono do

  it "should report correctly on undefined steps" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -fd spec/fixtures/reporter_features ), outstr)
    outarr = outstr.string.split(/\n/)
    outarr.should include '0 tests passed'
    outarr.should include '0 tests pending'
    outarr.should include '10 tests undefined'
    outarr.should include '0 tests failed'
    outarr.should include 'Build Nukumber test definitions something like this:'
    cli.runtime.tests_undefined.each do |test|
      outarr.should include "def #{test.name.nukesym}"
    end
  end

  it "should report correctly on a mixture of pending and undefined steps" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -fd spec/fixtures/reporter_features -dd test_defs_1 ), outstr)
    outarr = outstr.string.split(/\n/)
    outarr.should include '0 tests passed'
    outarr.should include '9 tests pending'
    outarr.should include '5 tests undefined'
    outarr.should include '0 tests failed'
    outarr.should include 'Build Nukumber test definitions something like this:'
    cli.runtime.tests_undefined.each do |test|
      outarr.should include "def #{test.name.nukesym}"
    end
  end

  it "should report correctly on a mixture of passing, failing and undefined steps" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -fd spec/fixtures/reporter_features -dd test_defs_2 ), outstr)
    outarr = outstr.string.split(/\n/)
    outarr.should include '8 tests passed'
    outarr.should include '0 tests pending'
    outarr.should include '3 tests undefined'
    outarr.should include '4 tests failed:'
    outarr.should include '    Tried to pass unexpected step "three" (expected "two")'
    outarr.should include '    Failed step "this"'
    outarr.should include '    Failed step "a postcondition": oh bugger'
    outarr.should include '    Last 2 steps not passed'
  end

  it "should still print steps that rely on an undefined background" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -fd spec/fixtures/reporter_features -dd test_defs_3 third.feature ), outstr)
    outarr = outstr.string.split(/\n/)
    outarr.should include '0 tests passed'
    outarr.should include '1 test pending'
    outarr.should include '2 tests undefined'
    outarr.should include '0 tests failed'
    outarr.should include '  Scenario: c1'
    outarr.should include '  Scenario: c2'
  end

end
