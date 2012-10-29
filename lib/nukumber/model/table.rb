module Nukumber

  module Model

    class Table
      attr_reader :headers, :rows, :lengths

      def initialize(rows)
        @headers, @rows, @lengths, @empty = [], [], [], true
        return if rows.nil?
        @empty = false
        rows.each_with_index do |r, i|
          if i == 0
            @headers = r.cells.map { |c| c.to_s }
            @lengths = @headers.map { |h| h.length }
          else
            row = []
            r.cells.each_with_index do |c, j|
              row << c.to_s
              @lengths[j] = [ c.to_s.length, @lengths[j] ].max
            end
            @rows << row
          end
        end
      end

      def empty?
        @empty
      end

      def row_count
        @rows.size
      end

      def row_hash(n)
        out = {}
        @rows[n].each_with_index do |val,i|
          out[@headers[i]] = val
        end
        out
      end

      def all_row_hashes
        out = []
        row_count.times { |i| out << row_hash(i) }
        out
      end

    end

  end

end
