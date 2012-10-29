module Nukumber

  module Model

    class ScenarioOutline < FeatureElement
      attr_accessor :tags, :examples

      def initialize(name, line, description, feature)
        super(name, line, description, feature)
        @tags = []
        @examples = nil
      end

      def keyword
        'Scenario Outline'
      end
    end

  end

end
