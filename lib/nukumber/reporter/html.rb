module Nukumber

  module Reporter

    class Html < Abstract

      private

      def add_row(nuke_table, row, table_node, status_class = nil)
        if row.nil? or row < 0
          array, tag = nuke_table.headers,   'th'
        else
          array, tag = nuke_table.rows[row], 'td'
        end
        row = node("tr", table_node)
        row['class'] = status_class if status_class
        array.each { |val| node(tag, row, {}, val) }
      end

      def node(type, parent = nil, attributes = {}, content = nil)
        div = Nokogiri::XML::Node.new(type, @doc)
        attributes.each_pair{ |k, v| div[k.to_s] = v }
        div.content = content unless content.nil?
        parent.add_child(div) unless parent.nil?
        div
      end


      public

      def initialize(out)
        @outstream = out
        @doc = Nokogiri::HTML::Document.new
        @html = node("html", @doc)
        node_head = node("head", @html)
        node_style = node("style", node_head, {:type => 'text/css'})
        node_style.inner_html = css
        node_body = node("body", @html)
        node("h1", node_body, {}, 'Nukumber test report')
      end

      def begin_feature(feature)
        @node_feature = node('div', @html.at_css('body'), {:class => 'feature'})
        node_header = node('div', @node_feature, {:class => 'header'})
        node("h2", node_header, {}, "#{feature.keyword}: #{feature.name}")
        unless feature.tags.empty?
          node("div", node_header, {:class => 'tags'}, feature.tags.join(' '))
        end
        unless feature.description.empty?
          node("p", node_header, {}, feature.description.gsub(/\n/,' '))
        end
      end

      def begin_element(element)
        @node_element = node("div", @node_feature, {:class => 'element'})
        node_header = node('div', @node_element, {:class => 'header'})
        node("h3", node_header, {}, "#{element.keyword}: #{element.name}")
        node("div", node_header, {:class => 'address'}, "#{element.feature.file_path.split('/').last}:#{element.line}")
        unless element.is_a? Nukumber::Model::Background or element.tags.empty?
          node("div", node_header, {:class => 'tags'}, element.tags.join(' '))
        end
        unless element.description.empty?
          node("p", node_header, {}, element.description.gsub(/\n/,' '))
        end
        if element.is_a? Nukumber::Model::ScenarioOutline
          element.steps.each { |step| print_step(step, :outline) }
          @node_ex_table = node("table", @node_element)
          add_row(element.examples.table, nil, @node_ex_table)
        end
      end

      def undefined_element(element)
        @node_element = node("div", @node_feature, {:class => 'element undefined'})
        node_header = node('div', @node_element, {:class => 'header'})
        node("h3", node_header, {}, "#{element.keyword}: #{element.name}")
        node("div", node_header, {:class => 'address'}, "#{element.feature.file_path.split('/').last}:#{element.line}")
        unless element.is_a? Nukumber::Model::Background or element.tags.empty?
          node("div", node_header, {:class => 'tags'}, element.tags.join(' '))
        end
        unless element.description.empty?
          node("p", node_header, {}, element.description.gsub(/\n/,' '))
        end
        element.steps.each { |step| print_step(step, :undefined) }
        if element.is_a? Nukumber::Model::ScenarioOutline
          @node_ex_table = node("table", @node_element)
          (0..element.examples.table.row_count).each do |i|
            add_row(element.examples.table, i - 1, @node_ex_table, 'undefined')
          end
        end
      end

      def print_step(step, status)
        node_step = node("div", @node_element, {:class => "step #{status.to_s}"})
        node("p", node_step, {}, "#{step.keyword}#{step.name}")
        unless step.args.empty?
          node_table = Nokogiri::XML::Node.new "table", @doc
          (0..step.args.row_count).each do |i|
            add_row(step.args, i - 1, node_table)
          end
          node_step.add_child node_table
        end
        @node_element['class'] = "element #{status.to_s}"
      end

      def print_example(table, row, status)
        add_row(table, row, @node_ex_table, status.to_s)
        unless @node_element['class'] == "element failed"
          @node_element['class'] = "element #{status.to_s}"
        end
      end

      def error(exception, element)
        node_error = node("div", @node_element, {:class => "error"})
        node("p", node_error, {}, exception.message)
        node_backtrace = node("div", node_error)
        filtered_backtrace(exception.backtrace).each do |l|
          node("p", node_backtrace, {}, l)
        end
        node("p", node_backtrace, {}, "#{element.feature.file_path}:#{element.line}")
        @node_element['class'] = 'element failed'
      end

      def final_report(passed, failed, pending, undefined)
        rpt = {:passed => passed, :failed => failed, :pending => pending, :undefined => undefined}
        node_final_report = node("div",  @html.at_css('body'), {:id => 'final_report'})
        %w( passed failed pending undefined ).each do |str|
          node("div", node_final_report, {:class => str}, "#{rpt[str.to_sym].size} test#{rpt[str.to_sym].size == 1 ? '' : 's'} #{str}")
        end
        node("div", node_final_report, {:class => "datetime"}, "#{Time.now}")
      end

      def print_skeleton_code(*)
      end

      def terminate()
        @outstream.puts @doc.to_html
      end

    end

  end

end
