module Nukumber

  module Reporter

    class Mono < Colour

      protected

      def puts_colour_indent(text, *)
        out = text
        @indent.times { out = INDENT + out }
        @outstream.puts out
      end

    end

  end

end
