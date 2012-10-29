require 'spec_helper'

describe Nukumber::Cli do

  before(:each) do
    @outstr = StringIO.new
  end

  it "should accept a features directory argument" do
    cli = Nukumber::Cli.new(%w( nukumber -fd spec/fixtures/cli/features ), @outstr)
    cli.runtime.tests_undefined.size.should == 4
  end

  it "should accept a defs directory argument" do
    cli = Nukumber::Cli.new(%w( nukumber -fd spec/fixtures/cli/features -dd test_definitions_odd ), @outstr)
    cli.runtime.tests_passed.size.should == 4
  end

  it "should accept a tag" do
    cli = Nukumber::Cli.new(%w( nukumber -fd spec/fixtures/cli/features -dd test_definitions_odd -t @tagged ), @outstr)
    cli.runtime.tests_passed.size.should == 1
    cli.runtime.tests_passed.first.name.should == 'CLI 1 (part 3)'
  end

  it "should accept a filename pattern" do
    cli = Nukumber::Cli.new(%w( nukumber -fd spec/fixtures/cli/features -dd test_definitions_odd cli2 ), @outstr)
    cli.runtime.tests_passed.size.should == 1
    cli.runtime.tests_passed.first.name.should == 'CLI 2'
  end

  it "should accept a filename pattern with a line filter" do
    cli = Nukumber::Cli.new(%w( nukumber -fd spec/fixtures/cli/features -dd test_definitions_odd cli1.feature:9 ), @outstr)
    cli.runtime.tests_passed.size.should == 1
    cli.runtime.tests_passed.first.name.should == 'CLI 1 (part 2)'
  end

  it "should accept a formatting argument" do
    cli = Nukumber::Cli.new(%w( nukumber -f c ), @outstr)
    cli.runtime.reporter.class.should == Nukumber::Reporter::Colour
  end

  it "should fail if an invalid format argument is provided" do
    expect { Nukumber::Cli.new(%w( nukumber -f x ), @outstr) }.to raise_error(RuntimeError)
  end

  it "should default to colour output for a TTY stream" do
    cli = Nukumber::Cli.new(%w( nukumber ), STDOUT)
    cli.runtime.reporter.class.should == Nukumber::Reporter::Colour
  end

  it "should default to monochrome output for a non-TTY stream" do
    cli = Nukumber::Cli.new(%w( nukumber ), @outstr)
    cli.runtime.reporter.class.should == Nukumber::Reporter::Mono
  end

  it "should provide help" do
    outstr1 = StringIO.new
    Nukumber::Cli.new(%w( nukumber -h ), outstr1)
    outarr = outstr1.string.split(/\n/)
    outstr2 = StringIO.new
    Nukumber::Cli.new(%w( nukumber --help ), outstr2)
    outarr2 = outstr2.string.split(/\n/)
    outarr.should == outarr2

    expectations = [
      'Usage: nukumber [options] [FILENAMEPATTERN[:LINE]]',
      '  -fd, --features X    : Specify feature directory name',
      '  -dd, --definitions X : Specify test definitions subdirectory name',
      '  -sd, --support X     : Specify support code subdirectory name',
      '  -t,  --tag X         : Only run tests with this tag',
      '  -f,  --format X      : Specify output format; options are c/colour,',
      '                         m/mono, h/html, s/silent',
      '  FILENAMEPATTERN      : Only run feature files whose names include',
      '                         this string',
      '  LINE                 : Optional addition to FILENAMEPATTERN; filters',
      '                         to a specific line number'
    ]

    expectations.each { |e| outarr.should include e }
  end

end
