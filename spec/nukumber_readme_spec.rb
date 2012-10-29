require 'spec_helper'

describe Nukumber::Cli do

  it "should pass the example from the README file" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -fd spec/fixtures/readme_feature ), outstr)
    cli.runtime.tests_passed.size.should == 2
  end

end
