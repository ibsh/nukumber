module Nukumber

  module Model

    class Feature
      attr_reader :name, :line, :description, :file_path
      attr_accessor :feature_elements, :tags, :background

      def initialize(name, line, description, file_path)
        if name.length == 0
          raise "Features must be named (#{file_path}:#{line})"
        elsif name[0,1] !~ /[a-zA-Z]/
          raise "Feature names must begin with a letter (#{file_path}:#{line})"
        end
        @name, @line, @description = name, line, description
        @feature_elements, @tags = [], []
        @background = nil
        @file_path = file_path
      end

      def keyword
        'Feature'
      end

      def to_s
        "#{keyword} \"#{name}\""
      end

    end

  end

end
