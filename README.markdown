jazz_money
=======
**Run your Jasmine specs without a browser**

The Math
----------
var jasmine = JsBdd;
var traceMonkey = Mozilla.JsEngine;
var johnson = Ruby + TraceMonkey;
var envJs = JsBrowser;
var harmony = johnson + envJs;

var jazzMoney = jasmine + harmony;

Using
---------
Install harmony: http://github.com/mynyml/harmony
    gem install jazz_money

To run create a file in your project (spec/javascript/run_jasmine_specs_with_jazz_money.rb would work):

    require 'rubygems'
    require 'jazz_money'

    library_files = [
      'public/javascripts/jquery-1.3.2.js',
      # etc
      'public/javascripts/my_js_codes.js',
      'spec/javascript/spec_helper.js'
    ]

    jasmine_spec_files = [
      'spec/javascript/my_js_codes_spec.js',
    ]

    JazzMoney::Runner.new(library_files, jasmine_spec_files).call
