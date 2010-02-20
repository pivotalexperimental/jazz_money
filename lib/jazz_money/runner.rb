module JazzMoney

  class Runner

    def initialize(js_includes, jasmine_spec_files)
      @js_includes = js_includes
      @jasmine_spec_files = jasmine_spec_files
      @page = Harmony::Page.new
    end

    def call
      load_jasmine


      load_js_includes
      load_html_fixtures
      load_jasmine_spec_files

      start_jasmine

      suites = @page.execute_js('jsApiReporter.suites();')

      reporter = JasmineReporter.new
      reporter.inject_into_page(@page)
      rs = RspecThread.start(suites, reporter)

      # jasmine uses setTimeout to run itself asynchronously, but AFAICT in the
      # johnson/env-js environment we must synchronously fire the timers using $wait.
      # so this line actually runs all the jasmine suites.
      @page.execute_js("$wait(-2000)")

      rs.join
    end


    private

    def start_jasmine
      @page.execute_js(<<-JS)
        var jasmineEnv = jasmine.getEnv();
        var jsApiReporter = new jasmine.JsApiReporter();
        jasmineEnv.addReporter(jsApiReporter);
        jasmineEnv.execute();
      JS
    end

    def load_jasmine_spec_files
      @jasmine_spec_files.each do |jasmine_spec_file|
        @page.load(jasmine_spec_file)
      end
    end

    def load_js_includes
      @js_includes.each do |library_js_file|
        @page.load(library_js_file)
      end
    end

    def load_html_fixtures
      fixtures = {}
      Dir["spec/javascript/fixtures/**/*.html"].each do |fixture_file|
        fixture = File.read(fixture_file)
        fixture_key = fixture_file.gsub("spec/javascript/fixtures/", "").gsub(".html", "")
        fixtures[fixture_key] = fixture
      end

      @page.execute_js(<<-JS)
        var Fixtures = {};
        Fixtures.all = eval(#{fixtures.to_json});
      JS

    end

    def load_jasmine
      dir = File.join(JAZZ_MONEY_DIR, "jasmine", "lib")
      ['json2.js', 'consolex.js', 'jasmine-0.10.0.js'].each do |file|
        @page.load(File.join(dir, file))
      end
    end

  end
end

