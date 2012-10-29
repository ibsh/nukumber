require 'time'

module Nukumber

  module Reporter

    class Abstract

      def initialize(out)
        @outstream = out
      end

      public

      def begin_feature(feature)                           end
      def begin_element(element)                           end
      def undefined_element(element)                       end
      def print_step(step, status)                         end
      def print_example(table, row, status)                end
      def error(exception, element)                        end
      def final_report(passed, failed, pending, undefined) end
      def print_skeleton_code(elements)                    end
      def terminate()                                      end

      protected
      def filtered_backtrace(btrace)

        filters = [
         /\/lib\d*\/ruby\//,
         /bin\//,
         /gems\//,
         /spec\/spec_helper\.rb/,
         /lib\/rspec\/(core|expectations|matchers|mocks)/
        ]

        filtered = []
        btrace.each do |l|
          filter = false
          filters.each do |b|
            if l.match b
              filter = true
              break
            end
          end
          filtered << l unless filter
        end
        filtered
      end

    end

  end

end
