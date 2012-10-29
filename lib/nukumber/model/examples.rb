module Nukumber

  module Model

    class Examples
      attr_reader :name, :line, :keyword
      attr_accessor :table

      def initialize(name, line, keyword, table)
        @name, @line, @keyword, @table = name, line, keyword, table
      end
    end

  end

end
