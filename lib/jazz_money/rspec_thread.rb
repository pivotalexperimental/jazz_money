module JazzMoney
  class RspecThread

    require 'spec'

    attr_reader :jasmine_reporter

    def self.start(suites, jasmine_reporter)
      t = Thread.start do
        me = new(suites, jasmine_reporter)
        me.run
      end
      t
    end

    def initialize(suites, jasmine_reporter)
      @suites = suites
      @jasmine_reporter = jasmine_reporter
    end

    def run
      declare_suites
      Spec::Runner.run
    end

    def declare_suites
      me = self
      @suites.each do |suite|
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
            raise "unknown type #{type} for #{suite_or_spec.inspect}"
          end
        end
      end
    end

    def declare_spec(parent, spec)
      me = self
      example_name = spec["name"]
      spec_id = spec['id']
      parent.it example_name do
        while me.jasmine_reporter.results[spec_id].nil?
          puts "sleeping while waiting for #{spec_id}"
          sleep 0.2
        end
        me.report_spec(me.jasmine_reporter.results[spec_id])
      end
    end

    def report_spec(spec_results)
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
