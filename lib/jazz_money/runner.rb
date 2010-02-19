module JazzMoney
  class Runner

    def initialize(library_js_files, jasmine_spec_files)
      @library_js_files = library_js_files
      @jasmine_spec_files = jasmine_spec_files
    end

    def call
      require 'spec/autorun'

      page = Harmony::Page.new

      load_jasmine(page)

      @library_js_files.each do |library_js_file|
        page.load(library_js_file)
      end

      fixtures = {}
      Dir["spec/javascript/fixtures/**/*.html"].each do |fixture_file|
        fixture = File.read(fixture_file)
        fixture_key = fixture_file.gsub("spec/javascript/fixtures/", "").gsub(".html", "")
        fixtures[fixture_key] = fixture
      end

      page.execute_js(<<-JS)
        var Fixtures = {};
        Fixtures.all = eval(#{fixtures.to_json});
        var jsApiReporter;
        var jasmineEnv = jasmine.getEnv();

        // probably no need for this
        (function() {
          jsApiReporter = new jasmine.JsApiReporter();
          jasmineEnv.addReporter(jsApiReporter);
        })();
      JS

      @jasmine_spec_files.each do |jasmine_spec_file|
        page.load(jasmine_spec_file)
      end

      page.execute_js(<<-JS)
        jasmineEnv.execute();
        // jasmine sets up asynchronous callbacks; this ensures they fire.
        $wait(-2000);
      JS

      bridge = JasmineRspecBridge.new(page)
      bridge.declare_suites
    end

    private

    def load_jasmine(page)
      dir = File.join(JAZZ_MONEY_DIR, "jasmine", "lib")
      ['json2.js', 'consolex.js', 'jasmine-0.10.0.js'].each do |file|
        page.load(File.join(dir, file))
      end
    end

  end
end

