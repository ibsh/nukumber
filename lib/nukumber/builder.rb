require "gherkin"

module Nukumber

  class GherkinBuilder
    # Builds the Nukumber Model from the output of the gherkin parser.

    include Gherkin::Rubify

    attr_reader :features

    def initialize
      @features = []
      @all_longsyms = []
      @all_shortsyms = []
    end

    def check_names
      if @all_longsyms.include? @current_feature_element.longsym
        raise Nukumber::NameCollisionError, @current_feature_element.longsym
      elsif @all_longsyms.include? @current_feature_element.shortsym or @all_shortsyms.include? @current_feature_element.shortsym
        raise Nukumber::NameCollisionWarning, @current_feature_element.shortsym
      end
      @all_longsyms << @current_feature_element.longsym
      @all_shortsyms << @current_feature_element.shortsym
    end

    def feature(gherkin_feature)
      @current_feature = Nukumber::Model::Feature.new(
        gherkin_feature.name.strip,
        gherkin_feature.line,
        gherkin_feature.description.strip,
        $feature_file_path
      )
      @current_feature.tags = gherkin_feature.tags.map(&:name)
      @features << @current_feature
    end

    def background(gherkin_background)
      @current_feature_element = Nukumber::Model::Background.new(
        gherkin_background.name.strip,
        gherkin_background.line,
        gherkin_background.description.strip,
        @current_feature
      )
      @current_feature.background = @current_feature_element
      check_names
    end

    def scenario(gherkin_scenario)
      @current_feature_element = Nukumber::Model::Scenario.new(
        gherkin_scenario.name.strip,
        gherkin_scenario.line,
        gherkin_scenario.description.strip,
        @current_feature
      )
      @current_feature_element.tags = gherkin_scenario.tags.map(&:name)
      @current_feature.feature_elements << @current_feature_element
      check_names
    end

    def scenario_outline(gherkin_outline)
      @current_feature_element = Nukumber::Model::ScenarioOutline.new(
        gherkin_outline.name.strip,
        gherkin_outline.line,
        gherkin_outline.description.strip,
        @current_feature
      )
      @current_feature_element.tags = gherkin_outline.tags.map(&:name)
      @current_feature.feature_elements << @current_feature_element
      check_names
    end

    def examples(gherkin_examples)
      @current_feature_element.examples = Nukumber::Model::Examples.new(
        gherkin_examples.name.strip,
        gherkin_examples.line,
        gherkin_examples.keyword,
        Nukumber::Model::Table.new(gherkin_examples.rows)
      )
    end

    def step(gherkin_step)
      @current_feature_element.steps << Nukumber::Model::Step.new(
        gherkin_step.name.strip,
        gherkin_step.line,
        gherkin_step.keyword,
        @current_feature_element,
        Nukumber::Model::Table.new(gherkin_step.rows)
      )
    end

    def eof
      @current_feature = nil
      @current_feature_element = nil
    end

    def syntax_error(*)
      raise Nukumber::SyntaxError
    end

  end

end
