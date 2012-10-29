require 'spec_helper'

describe Nukumber::Runtime do

  before(:each) do
    @directories = {
      :features => 'spec/fixtures/executing/',
      :definitions => 'test_definitions',
      :support => 'support'
    }
    os = StringIO.new
    @reporter = Nukumber::Reporter::Abstract.new(os)
  end

  it "should allow failures to include a text string" do
    @directories[:features] += 'features_2'
    nr = Nukumber::Runtime.new(@directories, [], [], @reporter)
    nr.tests_undefined.size.should == 0
    nr.tests_pending.size.should == 0
    nr.tests_passed.size.should == 1
    nr.tests_failed.size.should == 1
  end

  it "should find methods for feature elements, and measure undefined tests" do
    @directories[:features] += 'features_1'
    nr = Nukumber::Runtime.new(@directories, [], [], @reporter)
    nr.tests_undefined.size.should == 0
    nr.tests_pending.size.should == 1
    nr.tests_pending[0].class.should == Nukumber::Model::Scenario
    nr.tests_pending[0].name.should == "Something to execute"
  end

  it "should measure passing and failing tests" do
    @directories[:features] += 'features_2'
    nr = Nukumber::Runtime.new(@directories, [], [], @reporter)
    nr.tests_undefined.size.should == 0
    nr.tests_passed.size.should == 1
    nr.tests_passed[0].class.should == Nukumber::Model::Scenario
    nr.tests_passed[0].name.should == "Something to pass"
    nr.tests_failed.size.should == 1
    nr.tests_failed[0].class.should == Nukumber::Model::Scenario
    nr.tests_failed[0].name.should == "Something to fail"
  end

  it "should maintain instance variables from a Background to associated feature elements." do
    @directories[:features] += 'features_3'
    nr = Nukumber::Runtime.new(@directories, [], [], @reporter)
    nr.tests_undefined.size.should == 0
    nr.tests_pending.size.should == 0
    nr.tests_failed.size.should == 0
    nr.tests_passed.size.should == 1
  end

  it "should execute untagged Before hooks" do
    @directories[:features] += 'features_4'
    nr = Nukumber::Runtime.new(@directories, [], [4], @reporter)
    nr.tests_passed.size.should == 1
  end

  it "should execute tagged Before hooks after untagged Before hooks" do
    @directories[:features] += 'features_4'
    nr = Nukumber::Runtime.new(@directories, [], [8], @reporter)
    nr.tests_passed.size.should == 1
  end

  it "should execute untagged After hooks" do
    @directories[:features] += 'features_4'
    nr = Nukumber::Runtime.new(@directories, [], [13], @reporter)
    $after_var.should == 'bar'
  end

  it "should execute tagged After hooks before untagged After hooks" do
    @directories[:features] += 'features_4'
    nr = Nukumber::Runtime.new(@directories, [], [16], @reporter)
    $after_var.should == 'baz'
    $element.name.should == 'Checking the tagged after hook'
    $status.should == :passed
  end

  it "should execute After hooks even if the test fails" do
    @directories[:features] += 'features_4'
    nr = Nukumber::Runtime.new(@directories, [], [20], @reporter)
    nr.tests_failed.size.should == 1
    $after_var.should == 'bar'
  end

end
