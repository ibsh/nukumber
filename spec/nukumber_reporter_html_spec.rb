require 'spec_helper'

describe Nukumber::Reporter::Html do

  it "should report correctly on a mixture of pending and undefined steps" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/reporter_features -dd test_defs_1 ), outstr)
    html = Nokogiri::HTML(outstr.string)
    html.at_xpath('/html/body/div[@id="final_report"]/div[@class="passed"]').content.should == '0 tests passed'
    html.at_xpath('/html/body/div[@id="final_report"]/div[@class="pending"]').content.should == '9 tests pending'
    html.at_xpath('/html/body/div[@id="final_report"]/div[@class="undefined"]').content.should == '5 tests undefined'
    html.at_xpath('/html/body/div[@id="final_report"]/div[@class="failed"]').content.should == '0 tests failed'
  end

  it "should include embedded CSS in its reports" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/reporter_features -dd test_defs_2 ), outstr)
    html = Nokogiri::HTML(outstr.string)
    style = html.at_xpath('//head/style').content.split("\n")
    expectations = [
      '.feature {',
      '.element {',
      '.passed {',
      '.failed {',
      '.undefined {',
      '.error {'
    ]
    expectations.each { |e| style.should include e }
  end

  it "should include a report date and time in its reports" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/reporter_features -dd test_defs_2 ), outstr)
    html = Nokogiri::HTML(outstr.string)
    reportdate = Time.parse(html.at_xpath('/html/body/div[@id="final_report"]/div[@class="datetime"]').content)
    (Time.now - reportdate).should <= 60
    style = html.at_xpath('//head/style').content.split("\n")
    style.should include "#final_report .datetime {"
  end

  it "should report correctly on a mixture of passing, failing and undefined steps" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/reporter_features -dd test_defs_2 ), outstr)
    html = Nokogiri::HTML(outstr.string)
    html.at_xpath('//div[@class="passed"]').content.should == '8 tests passed'
    html.at_xpath('//div[@class="pending"]').content.should == '0 tests pending'
    html.at_xpath('//div[@class="undefined"]').content.should == '3 tests undefined'
    html.at_xpath('//div[@class="failed"]').content.should == '4 tests failed'
    errors = html.xpath('//div[@class="error"]/p')
    errors.size.should == 4
    error_strings = []
    errors.each {|e| error_strings << e.content }
    error_strings.should == [
      "Tried to pass unexpected step \"three\" (expected \"two\")",
      "Failed step \"this\"",
      "Failed step \"a postcondition\": oh bugger",
      "Last 2 steps not passed"
    ]
  end

  it "should have a titled div for each feature" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/cli/features ), outstr)
    html = Nokogiri::HTML(outstr.string)
    headed_features = html.xpath('//div[@class="feature"]/div[@class="header"]/h2')
    headed_features.size.should == 2
    headed_features[0].content.should == "Feature: Scenarios"
    headed_features[1].content.should == "Feature: Scenarios 2"
  end

  it "should have a titled, addressed div for each undefined element" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/cli/features ), outstr)
    html = Nokogiri::HTML(outstr.string)
    element_titles = html.xpath('//div[@class="element undefined"]/div[@class="header"]/h3')
    element_titles.size.should == 4
    element_titles[0].content.should == "Scenario: CLI 1 (part 1)"
    element_titles[1].content.should == "Scenario: CLI 1 (part 2)"
    element_titles[2].content.should == "Scenario: CLI 1 (part 3)"
    element_titles[3].content.should == "Scenario: CLI 2"
    element_addresses = html.xpath('//div[@class="element undefined"]/div[@class="header"]/div[@class="address"]')
    element_addresses.size.should == 4
    element_addresses[0].content.should == "cli1.feature:4"
    element_addresses[1].content.should == "cli1.feature:9"
    element_addresses[2].content.should == "cli1.feature:19"
    element_addresses[3].content.should == "cli2.feature:3"
  end

  it "should have a titled div for each undefined feature element, with steps" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/cli/features ), outstr)
    html = Nokogiri::HTML(outstr.string)
    element_headers = html.xpath('//div[@class="element undefined"]/div[@class="header"]/h3')
    element_headers.size.should == 4
    element_headers[0].content.should == "Scenario: CLI 1 (part 1)"
    element_headers[1].content.should == "Scenario: CLI 1 (part 2)"
    element_headers[2].content.should == "Scenario: CLI 1 (part 3)"
    element_headers[3].content.should == "Scenario: CLI 2"
    element_step_names = html.xpath('//div[@class="step undefined"]/p')
    element_step_names.size.should == 12
    element_step_names[0].content.should == "Given a precondition"
    element_step_names[1].content.should == "When an action"
    element_step_names[2].content.should == "Then a postcondition"
    step_table = html.xpath('//div[@class="step undefined"]/table').to_html
    step_table.should == "<table>\n<tr>\n<th>variable</th>\n<th>value</th>\n</tr>\n<tr>\n<td>a</td>\n<td>5</td>\n</tr>\n<tr>\n<td>b</td>\n<td>3</td>\n</tr>\n<tr>\n<td>c</td>\n<td>8</td>\n</tr>\n</table>"
  end

  it "should report properly on undefined scenario outlines" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/reporter_features first.feature:32 ), outstr)
    html = Nokogiri::HTML(outstr.string)
    step_table = html.xpath('//div[@class="element undefined"]/table')
    step_table.size.should == 1
    step_table.first.to_html.should == "<table>\n<tr class=\"undefined\">\n<th>object</th>\n<th>response</th>\n</tr>\n<tr class=\"undefined\">\n<td>cat</td>\n<td>vengeful</td>\n</tr>\n<tr class=\"undefined\">\n<td>dog</td>\n<td>dismayed</td>\n</tr>\n<tr class=\"undefined\">\n<td>ball</td>\n<td>stoic</td>\n</tr>\n</table>"
  end

  it "should show the comments from feature files" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/reporter_features first.feature ), outstr)
    html = Nokogiri::HTML(outstr.string)
    feature_comments = html.xpath('//div[@class="feature"]/div[@class="header"]/p')
    feature_comments.size.should == 1
    feature_comments.first.content.should == "Here are a couple of lines commenting on the feature."
    element_comments = html.xpath('//div[@class="element undefined"]/div[@class="header"]/p')
    element_comments.size.should == 2
    element_comments[0].content.should == "Comments on the first scenario go onto multiple lines."
    element_comments[1].content.should == "Just one line of commentary on the fourth scenario."
  end

  it "should show the tags from feature files" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/cli/features ), outstr)
    html = Nokogiri::HTML(outstr.string)
    feature_tags = html.xpath('//div[@class="feature"]/div[@class="header"]/div[@class="tags"]')
    feature_tags.size.should == 1
    feature_tags[0].content.should == "@ubertag @ubertag2"
    element_tags = html.xpath('//div[@class="element undefined"]/div[@class="header"]/div[@class="tags"]')
    element_tags.size.should == 1
    element_tags[0].content.should == "@tagged"
  end

  it "should still print steps that rely on an undefined background" do
    outstr = StringIO.new
    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/reporter_features -dd test_defs_3 third.feature ), outstr)
    html = Nokogiri::HTML(outstr.string)
    undefined_elements = html.xpath('//div[@class="element undefined"]/div[@class="header"]/h3')
    undefined_elements.size.should == 2
    pending_elements = html.xpath('//div[@class="element pending"]/div[@class="header"]/h3')
    pending_elements.size.should == 1
  end

  #it "should create a file if I tell it to (not a real test)" do
  #  file = File.new('out.htm','w')
  #  if file
  #    cli = Nukumber::Cli.new(%w( nukumber -f h -fd spec/fixtures/reporter_features -dd test_defs_2 ), file)
  #  end
  #  file.close
  #end

end
