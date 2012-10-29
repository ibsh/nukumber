module Nukumber

  module Reporter

    class Colour < Abstract

      protected

      INDENT = '  '

      def puts_empty_line
        @outstream.puts "\n"
      end

      def puts_colour_indent(text, colour_code)
        out = "\e[#{colour_code}m#{text}\e[0m"
        @indent.times { out = INDENT + out }
        @outstream.puts out
      end

      def puts_red(text)    puts_colour_indent(text, 31) end
      def puts_green(text)  puts_colour_indent(text, 32) end
      def puts_yellow(text) puts_colour_indent(text, 33) end
      def puts_cyan(text)   puts_colour_indent(text, 36) end
      def puts_grey(text)   puts_colour_indent(text, 37) end

      def puts_status(text, status)
        puts_green  text if status == :passed
        puts_red    text if status == :failed
        puts_cyan   text if status == :pending
        puts_cyan   text if status == :outline
        puts_yellow text if status == :undefined
      end

      def table_row_printable(table, row)
        if row.nil? or row < 0
          array = table.headers
        else
          array = table.rows[row]
        end
        str = "|"
        array.each_with_index do |val, i|
          str += " %-#{table.lengths[i]}s |" % [val]
        end
        str
      end

      public

      def begin_feature(feature)
        @indent = 0
        puts_cyan "#{feature.keyword}: #{feature.name}"
      end

      def begin_element(element)
        @indent = 1
        puts_cyan "#{element.keyword}: #{element.name}"
        puts_grey "#{element.feature.file_path.split('/').last}:#{element.line}"
        if element.is_a? Nukumber::Model::ScenarioOutline
          element.steps.each { |step| print_step(step, :outline) }
          @indent = 3
          puts_cyan table_row_printable(element.examples.table, nil)
        end
      end

      def undefined_element(element)
        @indent = 1
        puts_yellow "#{element.keyword}: #{element.name}"
        puts_grey "#{element.feature.file_path.split('/').last}:#{element.line}"
        element.steps.each { |step| print_step(step, :undefined) }
        if element.is_a? Nukumber::Model::ScenarioOutline
          @indent = 3
          (0..element.examples.table.row_count).each do |i|
            puts_status(table_row_printable(element.examples.table, i - 1), :undefined)
          end
        end
      end

      def print_step(step, status = :passed)
        @indent = 2
        puts_status("#{step.keyword}#{step.name}", status)
        @indent = 3
        unless step.args.empty?
          (0..step.args.row_count).each do |i|
            puts_status(table_row_printable(step.args, i - 1), status)
          end
        end
      end

      def print_example(table, row, status = :passed)
        puts_status(table_row_printable(table, row), status)
      end

      def error(exception, element)
        @indent = 2
        puts_red exception.message
        @indent = 3
        filtered_backtrace(exception.backtrace).each { |l| puts_red l }
        puts_red "#{element.feature.file_path}:#{element.line}"
      end

      def final_report(passed, failed, pending, undefined)
        @indent = 0
        puts_green "\n#{passed.size} test#{passed.size == 1 ? '' : 's'} passed"
        puts_cyan "#{pending.size} test#{pending.size == 1 ? '' : 's'} pending"
        puts_yellow "#{undefined.size} test#{undefined.size == 1 ? '' : 's'} undefined"
        puts_red "#{failed.size} test#{failed.size == 1 ? '' : 's'} failed#{failed.size == 0 ? '' : ':'}"
        @indent = 1
        failed.each { |f| puts_red "#{f.feature.file_path}:#{f.line} # #{f.name}" }
      end

      def print_skeleton_code(elements)
        @indent = 0
        puts_empty_line
        puts_yellow "Build Nukumber test definitions something like this:"
        puts_empty_line
        elements.each do |element|
          @indent = 0
          puts_yellow "def #{element.shortsym}"
          @indent = 1
          puts_yellow "# $args is a Hash (or Array of Hashes) representing any step arguments"
          puts_yellow "# $example is a Hash representing the current row for this outline" if element.is_a? Nukumber::Model::ScenarioOutline
          puts_yellow "# Now precede each \"pass\" line below with the code it describes..."
          puts_yellow "pending"
          element.steps.each do |step|
            puts_yellow "pass \"#{step.name.gsub('"', '\"')}\""
          end
          @indent = 0
          puts_yellow "end"
          puts_empty_line
        end
      end

    end

  end

end
