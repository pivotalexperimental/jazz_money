module JazzMoney
  class JasmineReporter
    def report_spec_results(spec_id, results_for_spec)
      results[spec_id] = JSON.parse(results_for_spec)
    end

    def results
      @results ||= {};
    end

    def inject_into_page(page)
      page.window['jazzMoneyReporter'] = self
      js = <<-JS
      jasmine.JsApiReporter.prototype.reportSpecResults = function(spec) {
        this.results_[spec.id] = {
          messages: spec.results().getItems(),
          result: spec.results().failedCount > 0 ? "failed" : "passed"
        };
        jazzMoneyReporter.report_spec_results(spec.id, JSON.stringify(this.results_[spec.id]))
      };
      JS
      page.execute_js(js)
    end
  end  
end
