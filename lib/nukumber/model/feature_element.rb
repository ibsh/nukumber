module Nukumber

  module Model

    class FeatureElement
      attr_reader :name, :line, :description
      attr_reader :feature
      attr_accessor :steps

      def initialize(name, line, description, feature)
        if name.length == 0
          raise "Feature elements must be named (#{feature.file_path}:#{line})"
        elsif name[0, 1] !~ /[a-zA-Z]/
          raise "Feature element names must begin with a letter (#{feature.file_path}:#{line})"
        end
        @name, @line, @description, @feature = name, line, description, feature
        @steps = []
      end

      def shortsym
        name.nukesym
      end

      def longsym
        (@feature.name.nukesym.to_s + LONGSYM_DELIM + name.nukesym.to_s).to_sym
      end

      def to_s
        "#{keyword} \"#{name}\""
      end

      def step_args
        step_args = []
        @steps.each do |s|
          step_args << s.args.all_row_hashes unless s.args.empty?
        end
        while step_args.is_a? Array and step_args.size == 1
          step_args = step_args.first
        end
        step_args
      end

    end

  end

end
