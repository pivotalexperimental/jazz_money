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

Note that there is an issue with installing JazzMoney using bundler. I get a segfault in Johnson:

    /Users/mag/.rvm/gems/ruby-1.8.7-p299@scratch/gems/johnson-2.0.0.pre3/lib/johnson/tracemonkey/tracemonkey.bundle: [BUG] Segmentation fault
    ruby 1.8.7 (2010-06-23 patchlevel 299) [i686-darwin10.4.0]

    Abort trap

Using
---------

### Running Jasmine Specs

The easiest way to run jasmine specs is to build a simple ruby file that can launch JazzMoney. If you are using the
[jasmine gem](http://github.com/pivotal/jasmine-gem), then the new, sexy way to do this is to piggy-back on your existing
jasmine.yml file. Check out [this gist](http://gist.github.com/564431) for an example.  If you don't have a jasmine.yml
file and don't feel like running the jasmine gem's generator to get one, [here is the default one you get](http://gist.github.com/564437)
if you run the generator. You *must* put this file in 'spec/javascripts/support/jasmine.yml' for JazzMoney (via the
jasmine gem) to pick it up.

YAML-haters can bypass the jasmine.yml file and build their file lists by hand. [Here is an example](http://gist.github.com/564450)
of doing just that.

You can put your runner file anywhere (for instance 'ruby spec/javascript/run_jasmine_specs_with_jazz_money.rb') and invoke
it with 'ruby'. You can also put similar code into a rake task.

### Using RSpec Options

JazzMoney uses the RSpec runner to run your Jasmine specs. This means that if you pass options that RSpec recognizes,
they will be parsed and used. For instance, to see colored and nested output instead of the standard progress dots,
run jazz_money as so:

    ruby spec/javascript/run_jasmine_specs_with_jazz_money.rb -f n -c

### Execution Environment

JazzMoney sets up a single window instance, and all your specs are run within that window. If you are using
the jasmine gem, your tests should run with little modification (except maybe your HTML fixture loading...see below).

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

Known Issues
---------

JazzMoney doesn't like prototype.js. On version 1.6.0.3, it somehow causes JSON.stringify to escape all double-quote
marks. We use JSON to transfer the entire suite definition over from json to ruby, and the ruby JSON parser doesn't
like this and blows up with an error that looks like this:

    /Library/Ruby/Gems/1.8/gems/json_pure-1.4.6/lib/json/common.rb:146:in `parse': 655: unexpected token at '"[{\"id\": 0, \"name\": \"Player\", \"type\": \"suite\", \"children\": [{\"id\": 0, \"name\": \"should be able to play a Song\", \"type\": \"spec\", \"children\": []}, {\"id\": 1, \"name\": \"when song has been paused\", \"type\": \"suite\", \"children\": [{\"id\": 1, \"name\": \"should indicate that the song is currently paused\", \"type\": \"spec\", \"children\": []}, {\"id\": 2, \"name\": \"should be possible to resume\", \"type\": \"spec\", \"children\": []}]}, {\"id\": 3, \"name\": \"tells the current song if the user has made it a favorite\", \"type\": \"spec\", \"children\": []}, {\"id\": 2, \"name\": \"#resume\", \"type\": \"suite\", \"children\": [{\"id\": 4, \"name\": \"should throw an exception if song is already playing\", \"type\": \"spec\", \"children\": []}]}]}]"' (JSON::ParserError)
	    from /Library/Ruby/Gems/1.8/gems/json_pure-1.4.6/lib/json/common.rb:146:in `parse'
	    from /Library/Ruby/Gems/1.8/gems/jazz_money-0.0.4/lib/jazz_money/runner.rb:33:in `call'
	    from spec/javascripts/run_jasmine_specs_with_jazz_money.rb:5

On prototype 1.6.1, I get a different error, and I have no clue what's going on here:

    xpath failure: ReferenceError: alert is not defined
    /Library/Ruby/Gems/1.8/gems/envjs-0.2.0/lib/envjs/static.js:20097 [JavaScript]: alert is not defined (Johnson::Error)
    	from /Library/Ruby/Gems/1.8/gems/envjs-0.2.0/lib/envjs/static.js:20043 [JavaScript]
    	from /Library/Ruby/Gems/1.8/gems/envjs-0.2.0/lib/envjs/static.js:20552 [JavaScript]
    	from /Library/Ruby/Gems/1.8/gems/envjs-0.2.0/lib/envjs/static.js:20522 [JavaScript]
    	from /Library/Ruby/Gems/1.8/gems/envjs-0.2.0/lib/envjs/static.js:20487 [JavaScript]
    	from /Library/Ruby/Gems/1.8/gems/envjs-0.2.0/lib/envjs/static.js:20019 [JavaScript]
    	from /Library/Ruby/Gems/1.8/gems/envjs-0.2.0/lib/envjs/static.js:19941 [JavaScript]
    	from /Library/Ruby/Gems/1.8/gems/envjs-0.2.0/lib/envjs/static.js:19772:in `xPathStep' [JavaScript]
    	from /Library/Ruby/Gems/1.8/gems/envjs-0.2.0/lib/envjs/static.js:19777:in `xPathStep' [JavaScript]
    	 ... 21 levels...
    	from /Library/Ruby/Gems/1.8/gems/jazz_money-0.0.4/lib/jazz_money/jasmine_runner.rb:74:in `load_js_includes'
    	from /Library/Ruby/Gems/1.8/gems/jazz_money-0.0.4/lib/jazz_money/jasmine_runner.rb:35:in `start'
    	from /Library/Ruby/Gems/1.8/gems/jazz_money-0.0.4/lib/jazz_money/runner.rb:28:in `call'
    	from spec/javascripts/run_jasmine_specs_with_jazz_money.rb:5

Development
---------
If you clone the repo and want to run specs, that can be done with

    spec spec/

Pull requests gladly accepted!

Copyright (c) 2008-2010 Pivotal Labs. This software is licensed under the MIT License.