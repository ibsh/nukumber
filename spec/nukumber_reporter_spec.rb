require 'spec_helper'

describe Nukumber::Reporter do

  it "should be able to work silently" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f s ), outstr)
    outstr.string.should == ''
  end

  it "should be able to report in monochrome" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f m ), outstr)
    outarr = outstr.string.split(/\n/)
    outarr.should == [
      "",
      "0 tests passed",
      "0 tests pending",
      "0 tests undefined",
      "0 tests failed"
    ]
  end

  it "should be able to report in colour" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f c ), outstr)
    outarr = outstr.string.split(/\n/)
    outarr.should == [
      "\e[32m",
      "0 tests passed\e[0m",
      "\e[36m0 tests pending\e[0m",
      "\e[33m0 tests undefined\e[0m",
      "\e[31m0 tests failed\e[0m"
    ]
  end

  it "should be able to report in HTML" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h ), outstr)
    outarr = outstr.string.split(/\n/)
    [
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">",
      "<html>",
      "<head><style type=\"text/css\">",
      # snip actual css
      "</style></head>",
      "<body>",
      "<h1>Nukumber test report</h1>",
      "<div id=\"final_report\">",
      "<div class=\"passed\">0 tests passed</div>",
      "<div class=\"failed\">0 tests failed</div>",
      "<div class=\"pending\">0 tests pending</div>",
      "</div>",
      "</body>",
      "</html>"
    ].each { |l| outarr.should include l }
  end

end
