module Nukumber

  module Model

    class Scenario < FeatureElement
      attr_accessor :tags

      def initialize(name, line, description, feature)
        super(name, line, description, feature)
        @tags = []
      end

      def keyword
        'Scenario'
      end
    end

  end

end
