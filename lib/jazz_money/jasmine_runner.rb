module JazzMoney

  class JasmineRunner
    
    def initialize(page, jasmine_spec_files, js_includes, observer, html_fixture_dir = 'spec/javascripts/fixtures')
      @page = page
      @observer = observer
      @js_includes = js_includes
      @jasmine_spec_files = jasmine_spec_files
      @html_fixture_dir = html_fixture_dir
    end

    def start
      load_html_fixtures
      load_jasmine
      @page.window['jazzMoneyReporter'] = @observer
      js = <<-JS
      jasmine.JsApiReporter.prototype.reportSpecResults = function(spec) {
        var messages = [];
        var results = spec.results().getItems();
        for (var i = 0; i < results.length; i++ ) {
          var item = results[i];
          var message = item.message
          var trace = item.trace.stack
          messages.push({message : message, stack_trace : trace})
        }
        this.results_[spec.id] = {
          messages: messages,
          result: spec.results().failedCount > 0 ? "failed" : "passed"
        };
        jazzMoneyReporter.report_spec_results(spec.id, JSON.stringify(this.results_[spec.id]));
      };
      JS
      @page.execute_js(js)
      load_js_includes
      load_jasmine_spec_files
      start_jasmine
    end

    def wait
      @page.execute_js("$wait(-2000)")
    end

    private

    def load_html_fixtures
      fixtures = {}
      Dir["#{@html_fixture_dir}/**/*.html"].each do |fixture_file|
        fixture = File.read(fixture_file)
        fixture_key = fixture_file.gsub(@html_fixture_dir + "/", "").gsub(".html", "")
        fixtures[fixture_key] = fixture
      end

      @page.execute_js(<<-JS)
        var JazzMoney = {};
        JazzMoney.allFixtures = eval(#{fixtures.to_json});
        JazzMoney.loadFixture = function(fixturePath) {
          document.getElementsByTagName('body')[0].innerHTML = this.allFixtures[fixturePath];
        }
      JS
    end

    def load_jasmine
      jasmine_gemspecs = Gem.searcher.find_all('jasmine')
      correct_jasmine_gemspec = jasmine_gemspecs.detect { |gemspec| gemspec.version.to_s == "0.11.1.0" }
      jasmine_gem_path = correct_jasmine_gemspec.full_gem_path
      jasmine_js_files_path = File.join(jasmine_gem_path, "jasmine", "lib")
      ['consolex.js', 'jasmine.js'].each do |file|
        @page.load(File.join(jasmine_js_files_path, file))
      end
    end

    def load_js_includes
      @js_includes.each do |library_js_file|
        @page.load(library_js_file)
      end
    end

    def load_jasmine_spec_files
      @jasmine_spec_files.each do |jasmine_spec_file|
        @page.load(jasmine_spec_file)
      end
    end

    def start_jasmine
      @page.execute_js(<<-JS)
        var jasmineEnv = jasmine.getEnv();
        var jsApiReporter = new jasmine.JsApiReporter();
        jasmineEnv.addReporter(jsApiReporter);
        jasmineEnv.execute();
      JS
    end
  end
end
