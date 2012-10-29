module Nukumber

  module Model

    class Step
      attr_reader :name, :line, :keyword, :element, :args

      def initialize(name, line, keyword, element, args)
        @name, @line, @keyword, @element, @args = name, line, keyword, element, args
      end
    end

  end

end
