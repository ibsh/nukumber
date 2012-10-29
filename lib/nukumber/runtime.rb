module Nukumber

  class Runtime

    def initialize(dirs, filenames, filters, reporter)

      @reporter = reporter

      builder = Nukumber::GherkinBuilder.new

      if filters.empty?
        filter_f = builder
      else
        filter_f = Gherkin::Formatter::FilterFormatter.new(builder, filters)
      end
      tag_f = Gherkin::Formatter::TagCountFormatter.new(filter_f, {})
      parser = Gherkin::Parser::Parser.new(tag_f)

      parse_feature_files(parser, dirs, filenames)
      validate_features(builder.features)

      $before_hooks = {}
      $after_hooks  = {}
      old_methods   = Object.private_methods

      # Load all user-space Ruby files
      Dir[Dir.pwd + "/#{dirs[:features]}/#{dirs[:support]}/env.rb"].each   { |f| load f }
      Dir[Dir.pwd + "/#{dirs[:features]}/#{dirs[:support]}/*.rb"].each     { |f| load f }
      Dir[Dir.pwd + "/#{dirs[:features]}/#{dirs[:definitions]}/*.rb"].each { |f| load f }

      user_methods = Object.private_methods - old_methods

      @expected_steps  = []
      @tests_passed    = []
      @tests_failed    = []
      @tests_pending   = []
      @tests_undefined = []

      # Run all relevant features
      builder.features.each { |feature| run_feature feature }

      # Report
      @reporter.final_report(@tests_passed, @tests_failed, @tests_pending, @tests_undefined)

      # Provide code snippets as appropriate
      @reporter.print_skeleton_code @tests_undefined unless @tests_undefined.empty?

      @reporter.terminate

      user_methods.each { |method_sym| Object.send(:remove_method, method_sym) }

    end

    def pass (step_name)
      raise "Tried to pass without a step name" unless step_name.is_a? String
      if @expected_steps.empty?
        raise "Tried to pass unexpected step \"#{step_name}\" (expected test to be finished)"
      elsif @expected_steps.first.name != step_name
        raise "Tried to pass unexpected step \"#{step_name}\" (expected \"#{@expected_steps.first.name}\")"
      else
        @reporter.print_step(@expected_steps.first, :passed) unless @executing_element.is_a? Nukumber::Model::ScenarioOutline
        @expected_steps.shift
      end
    end

    def pending (*)
      raise Nukumber::PendingTestError
    end

    def fail (err_msg = nil)
      err_msg = ": #{err_msg}" unless err_msg.nil?
      if @expected_steps.empty?
        raise "Failed after all steps completed#{err_msg}"
      else
        raise "Failed step \"#{@expected_steps.first.name}\"#{err_msg}"
      end
    end

    private

    def parse_feature_files(parser, dirs, filenames)
      Dir[Dir.pwd + "/#{dirs[:features]}/*.feature"].each do |ff_path|
        unless filenames.empty?
          skip = false
          filenames.each { |f| skip = true unless ff_path.include? f }
          next if skip
        end
        $feature_file_path = ff_path # TODO: this global is crap
        parser.parse(IO.read(ff_path), ff_path, 0)
      end
    end

    def validate_features(features)
      features.each do |f|
        f.feature_elements.each do |e|
          id = "#{e.name}, #{f.file_path}:#{e.line}"
          if e.is_a? Nukumber::Model::ScenarioOutline and e.examples.nil?
            raise Nukumber::SyntaxError, "Missing examples from element: #{id}"
          end
          if e.is_a? Nukumber::Model::ScenarioOutline and e.examples.table.rows.empty?
            raise Nukumber::SyntaxError, "Example table from element has no rows: #{id}"
          end
          e.steps.each do |s|
            if !s.args.empty? and s.args.rows.empty?
              raise Nukumber::SyntaxError, "Arguments table in element has no rows: #{id}"
            end
          end
        end
      end
    end

    def check_for_element_method(element)
      raise Nukumber::UndefinedTestError unless respond_to?(element.shortsym, true) or respond_to?(element.longsym, true)
    end

    def run_feature(feature)
      @reporter.begin_feature feature

      all_elements = []
      all_elements << feature.background unless feature.background.nil?
      all_elements += feature.feature_elements

      # find undefined tests
      all_elements.each do |element|
        begin
          check_for_element_method(element)
        rescue Nukumber::UndefinedTestError
          @tests_undefined << element
        end
      end

      # and attempt to run tests
      @background_undefined = false
      all_elements.each do |element|
        begin
          check_for_element_method element
          @reporter.begin_element element
          @executing_element = element
          run_outline_element(element) if element.is_a? Nukumber::Model::ScenarioOutline
          run_single_element(element) unless element.is_a? Nukumber::Model::ScenarioOutline
        rescue Nukumber::UndefinedTestError
          @reporter.undefined_element(element)
          @background_undefined = true if element.is_a? Nukumber::Model::Background
          next
        rescue
          return if element.is_a? Nukumber::Model::Background
        end
      end

    end

    def run_single_element(element)
      if element.is_a? Nukumber::Model::Background
        elements_at_stake = element.feature.feature_elements
      else
        elements_at_stake = [element]
      end
      $example = nil
      status = nil
      begin
        before_hooks(element)
        execute_element(element)
        @tests_passed << element unless element.is_a? Nukumber::Model::Background
        status = :passed
      rescue Nukumber::PendingTestError
        @expected_steps.each { |s| @reporter.print_step(s, :pending) }
        @tests_pending += elements_at_stake
        status = :pending
        raise RuntimeError if element.is_a? Nukumber::Model::Background
      rescue => e
        @reporter.print_step(@expected_steps.first, :failed) unless @expected_steps.empty?
        @expected_steps.shift
        @expected_steps.each { |s| @reporter.print_step(s, :pending) }
        @reporter.error(e, element)
        @tests_failed += elements_at_stake
        status = :failed
        raise RuntimeError if element.is_a? Nukumber::Model::Background
      ensure
        after_hooks(element, status)
      end
    end

    def run_outline_element(element)
      element.examples.table.rows.size.times do |i|
        $example = element.examples.table.row_hash(i)
        status = nil
        begin
          before_hooks(element)
          execute_element(element)
          @reporter.print_example(element.examples.table, i, :passed)
          @tests_passed << element
          status = :passed
        rescue Nukumber::PendingTestError
          @reporter.print_example(element.examples.table, i, :pending)
          @tests_pending << element
          status = :pending
        rescue => e
          @reporter.print_example(element.examples.table, i, :failed)
          @reporter.error(e, element)
          @tests_failed << element
          status = :failed
        ensure
          after_hooks(element, status)
        end
      end
    end

    def before_hooks(element)
      $before_hooks[:each].each { |p| self.instance_eval &p } if $before_hooks[:each]
      element.tags.each do |t|
        $before_hooks[t.to_sym].each { |p| self.instance_eval &p } if $before_hooks[t.to_sym]
      end
    end

    def after_hooks(element, status)
      element.tags.each do |t|
        $after_hooks[t.to_sym].each { |p| instance_exec(element, status, &p) } if $after_hooks[t.to_sym]
      end
      $after_hooks[:each].each { |p| instance_exec(element, status, &p) } if $after_hooks[:each]
    end

    def execute_element(element)
      @expected_steps = element.steps.clone
      $args = element.step_args
      raise Nukumber::PendingTestError if @background_undefined

      send(element.shortsym) if respond_to?(element.shortsym, true)
      send(element.longsym)  if respond_to?(element.longsym,  true)

      unless @expected_steps.empty?
        raise "Last #{@expected_steps.size > 1 ? "#{@expected_steps.size} steps" : 'step'} not passed"
      end
    end

  end

end
