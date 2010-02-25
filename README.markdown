JazzMoney
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

Install
---------
Install harmony by following instructions here: [http://github.com/mynyml/harmony](http://github.com/mynyml/harmony)

Install JazzMoney
    gem install jazz_money

Using
---------

### Run Specs

To run your specs, create a file in your project (spec/javascript/run_jasmine_specs_with_jazz_money.rb would work):

    require 'rubygems'
    require 'jazz_money'

    javascript_files = [
      'public/javascripts/jquery-1.3.2.js',
      'public/javascripts/my_js_codes.js',
      'spec/javascript/spec_helper.js'
    ]

    jasmine_spec_files = [
      'spec/javascript/my_js_codes_spec.js',
    ]

    JazzMoney::Runner.new(javascript_files, jasmine_spec_files).call

You can then run this file on the command line using 'ruby'

### Execution Environment

JazzMoney sets up a single window instance, and all your specs are run within that window. If you are using
jasmine-ruby, your tests should run with little modification.

### Fixtures

If you need HTML fixtures, JazzMoney has an API for that:

  beforeEach(function() {
    JazzMoney.loadFixture("projects");
  });

In the code above, a file named 'spec/javascript/fixtures/projects.html' will be loaded and its entire contents will
be dumped into the innerHTML of the body tag of the current window. You can add directory structure underneath the top
level fixtures dir if you like.

### CSS

There is no support for loading CSS rules from an external file, but early indications are that env.js has some support
for CSS. Stay tuned.
