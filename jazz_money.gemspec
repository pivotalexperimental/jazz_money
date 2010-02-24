Gem::Specification.new do |s|
  s.name                = "jazz_money"
  s.summary             = "Jasmine + Harmony"
  s.description         = "Jasmine + Harmony"
  s.author              = "Mike Grafton"
  s.email               = "mike@pivotallabs.com"
  s.homepage            = "http://github.com/pivotal/jazz_money"
  s.rubyforge_project   = ""
  s.require_path        = "lib"
  s.version             =  "0.0.0"
  s.files               =  s.files = [
     "lib/jazz_money.rb",
     "lib/jazz_money/runner.rb",
     "lib/jazz_money/rspec_thread.rb",
     "lib/jazz_money/jasmine_runner.rb",
     "jasmine/lib/TrivialReporter.js",
     "jasmine/lib/consolex.js",
     "jasmine/lib/jasmine-0.10.0.js",
     "jasmine/lib/jasmine.css",
     "jasmine/lib/json2.js",
  ]

  s.add_dependency 'harmony', '0.5.2'
end
