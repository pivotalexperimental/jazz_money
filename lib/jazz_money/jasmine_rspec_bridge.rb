module JazzMoney
  
  class JasmineRspecBridge

    attr_accessor :suites

    def initialize(harmony_page)
      @harmony_page = harmony_page
      load_suite_info
      @spec_results = {}
    end

    def load_suite_info
      @suites = JSON.parse(@harmony_page.execute_js('JSON.stringify(jsApiReporter.suites())'))
    end

    def results_for(spec_id)
      spec_id = spec_id.to_s
      return @spec_results[spec_id] if @spec_results[spec_id]

      @spec_results[spec_id] = JSON.parse(@harmony_page.execute_js("JSON.stringify(jsApiReporter.resultsForSpec(#{spec_id}))"))

      @spec_results[spec_id]
    end

    def declare_suites
      me = self
      suites.each do |suite|
        declare_suite(self, suite)
      end
    end

    def declare_suite(parent, suite)
      me = self
      parent.describe suite["name"] do
        suite["children"].each do |suite_or_spec|
          type = suite_or_spec["type"]
          if type == "suite"
            me.declare_suite(self, suite_or_spec)
          elsif type == "spec"
            me.declare_spec(self, suite_or_spec)
          else
            raise "unknown type #{type}"
          end
        end
      end
    end

    def declare_spec(parent, spec)
      me = self
      parent.it spec["name"] do
        me.report_spec(spec["id"])
      end
    end

    def report_spec(spec_id)
      spec_results = results_for(spec_id)

      if (spec_results['result'] != 'passed')

        fail_messages_hashes = spec_results['messages'].reject {|message| message["message"] =~ /Passed/}
        all_fail_messages = []
        fail_messages_hashes.each do |message|
          all_fail_messages << message["message"]
          js_stack_lines = message["trace"]["stack"].split("\n").select {|stack_line| stack_line =~ /spec\/javascript/}
          js_stack_lines.each {|stack_line| all_fail_messages << stack_line.gsub("()@", "./")}
        end

        Spec::Expectations.fail_with(all_fail_messages.join("\n"))
      end

    end

  end

end
