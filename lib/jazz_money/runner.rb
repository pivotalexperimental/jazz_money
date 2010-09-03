module JazzMoney

  # TODO: rename. easy to confuse with JasmineRunner. or rename JasmineRunner.
  class Runner

    def self.from_jasmine_config
      jasmine_config = Jasmine::Config.new

      spec_files = jasmine_config.spec_files.map { |path| File.join(jasmine_config.spec_dir, path) }
      helper_files = jasmine_config.helpers.map { |path| File.join(jasmine_config.spec_dir, path) }
      src_files = jasmine_config.src_files.map { |path| File.join(jasmine_config.src_dir, path) }
      
      self.new(src_files, helper_files + spec_files)
    end

    def initialize(js_includes, jasmine_spec_files)
      @page = Harmony::Page.new
      @jasmine_runner = JasmineRunner.new(@page, jasmine_spec_files, js_includes, self)
      @js_includes = js_includes
      @jasmine_spec_files = jasmine_spec_files
    end

    def call
      @jasmine_runner.start

      # johnson is not thread-safe, so serialize the suites into ruby objects
      suites = JSON.parse(@page.execute_js('JSON.stringify(jsApiReporter.suites());'))
      rspec_thread = RspecThread.start(suites, self)
      @jasmine_runner.wait
      rspec_thread.join
    end

    def report_spec_results(spec_id, results_for_spec)
      results[spec_id] = JSON.parse(results_for_spec)
    end

    def results
      @results ||= {};
    end

  end
end

