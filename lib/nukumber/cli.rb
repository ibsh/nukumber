module Nukumber

  class Cli

    def initialize(args, out_stream = STDOUT)

      directories = {
        :features => 'features',
        :definitions => 'test_definitions',
        :support => 'support'
      }

      reporter_type = 'Mono'
      reporter_type = 'Colour' if out_stream.tty?

      filters = []
      filenames = []

      i = 0
      while i < args.size do

        # named arguments
        if %w( -h --help ).include? args[i]
          print_help(out_stream)
          return

        elsif %w( -fd --features ).include? args[i] and (i+1) < args.size
          directories[:features] = args[i+1]
          i += 2
          next

        elsif %w( -sd --support ).include? args[i] and (i+1) < args.size
          directories[:support] = args[i+1]
          i += 2
          next

        elsif %w( -dd --definitions ).include? args[i] and (i+1) < args.size
          directories[:definitions] = args[i+1]
          i += 2
          next

        elsif %w( -t --tag ).include? args[i] and (i+1) < args.size
          filters << args[i+1] if args[i+1][0, 1] == '@'
          i += 2
          next

        elsif %w( -f --format ).include? args[i] and i + 1 < args.size
          if %w( c colour ).include? args[i+1]
            reporter_type = 'Colour'
          elsif %w( m mono ).include? args[i+1]
            reporter_type = 'Mono'
          elsif %w( h html ).include? args[i+1]
            reporter_type = 'Html'
          elsif %w( s silent ).include? args[i+1]
            reporter_type = 'Abstract'
          else
            raise "\"#{args[i+1]}\" is an invalid argument to \"#{args[i]}\""
          end
          i += 2
          next
        end

        # filename patterns
        arr = args[i].split(/:/)
        filenames << arr.shift
        arr.each { |n| filters << n.to_i unless n.to_i == 0 }

        # increment and loop
        i += 1
      end

      reporter = eval("Nukumber::Reporter::#{reporter_type}").new(out_stream)

      @runtime = Nukumber::Runtime.new(
        directories,
        filenames,
        filters,
        reporter
      )

    end

    def print_help(out_stream)
      out_stream.puts <<HERE
Usage: nukumber [options] [FILENAMEPATTERN[:LINE]]
  -fd, --features X    : Specify feature directory name
  -dd, --definitions X : Specify test definitions subdirectory name
  -sd, --support X     : Specify support code subdirectory name
  -t,  --tag X         : Only run tests with this tag
  -f,  --format X      : Specify output format; options are c/colour,
                         m/mono, h/html, s/silent
  FILENAMEPATTERN      : Only run feature files whose names include
                         this string
  LINE                 : Optional addition to FILENAMEPATTERN; filters
                         to a specific line number
HERE
    end

  end

end
