require 'spec_helper'

describe Nukumber::Runtime do

  before(:each) do
    @directories = {
      :features => 'spec/fixtures/parsing/',
      :definitions => 'test_definitions',
      :support => 'support'
    }
    os = StringIO.new
    @reporter = Nukumber::Reporter::Abstract.new(os)
  end

  it "should model features containing scenarios, and measure undefined tests" do
    @directories[:features] += 'features_1'
    nr = Nukumber::Runtime.new(@directories, [], [], @reporter)
    nr.tests_undefined.size.should == 1
    nr.tests_undefined[0].class.should == Nukumber::Model::Scenario
    nr.tests_undefined[0].name.should == 'A scenario'
  end

  it "should model features containing scenario outlines" do
    @directories[:features] += 'features_2'
    nr = Nukumber::Runtime.new(@directories, [], [], @reporter)
    nr.tests_undefined.size.should == 1
    nr.tests_undefined[0].class.should == Nukumber::Model::ScenarioOutline
    nr.tests_undefined[0].name.should == "A test outline"
  end

  it "should model features containing backgrounds" do
    @directories[:features] += 'features_3'
    nr = Nukumber::Runtime.new(@directories, [], [], @reporter)
    nr.tests_undefined.size.should == 3
    nr.tests_undefined[0].class.should == Nukumber::Model::Background
    nr.tests_undefined[0].name.should == "Background for a couple of tests"
  end

  it "should be able to filter by tag" do
    @directories[:features] += 'features_4'
    nr = Nukumber::Runtime.new(@directories, [], %w( @tagged ), @reporter)
    nr.tests_undefined.size.should == 1
    nr.tests_undefined[0].class.should == Nukumber::Model::Scenario
    nr.tests_undefined[0].name.should == "Something else to test"
  end

  it "should be able to filter by filename" do
    @directories[:features] += 'features_4'
    nr = Nukumber::Runtime.new(@directories, ['first.feature'], [], @reporter)
    nr.tests_undefined.size.should == 2
    nr.tests_undefined[0].class.should == Nukumber::Model::Scenario
    nr.tests_undefined[0].name.should == "Something to test"
    nr.tests_undefined[1].class.should == Nukumber::Model::Scenario
    nr.tests_undefined[1].name.should == "Something else to test"
  end

  it "should be able to filter by filename and line" do
    @directories[:features] += 'features_4'
    nr = Nukumber::Runtime.new(@directories, ['first.feature'], [9], @reporter)
    nr.tests_undefined.size.should == 1
    nr.tests_undefined[0].name.should == "Something else to test"
  end

  it "should fail when a user has forgotten the examples section for an outline" do
    @directories[:features] += 'malformed'
    expect { Nukumber::Runtime.new(@directories, ['first.feature'], [4], @reporter) }.to raise_error(Nukumber::SyntaxError)
  end

  it "should fail when a user has forgotten the examples table for an outline" do
    @directories[:features] += 'malformed'
    expect { Nukumber::Runtime.new(@directories, ['first.feature'], [9], @reporter) }.to raise_error(Nukumber::SyntaxError)
  end

  it "should fail when a user has forgotten the examples rows for an outline" do
    @directories[:features] += 'malformed'
    expect { Nukumber::Runtime.new(@directories, ['first.feature'], [15], @reporter) }.to raise_error(Nukumber::SyntaxError)
  end

  it "should fail when a user has forgotten the rows of an arguments table" do
    @directories[:features] += 'malformed'
    expect { Nukumber::Runtime.new(@directories, ['second.feature'], [4], @reporter) }.to raise_error(Nukumber::SyntaxError)
  end

  it "should fail when two tests have colliding names" do
    @directories[:features] += 'malformed'
    expect { Nukumber::Runtime.new(@directories, ['third.feature'], [], @reporter) }.to raise_error(Nukumber::NameCollisionError)
  end

end
