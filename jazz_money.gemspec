Gem::Specification.new do |s|
  s.name                = "jazz_money"
  s.summary             = "Jasmine + Harmony"
  s.description         = "Jasmine + Harmony"
  s.author              = "Mike Grafton"
  s.email               = "mike@pivotallabs.com"
  s.homepage            = "http://github.com/pivotalexperimental/jazz_money"
  s.rubyforge_project   = ""
  s.require_path        = "lib"
  s.version             =  "0.0.4"
  s.files               =  s.files = [
     "lib/jazz_money.rb",
     "lib/jazz_money/runner.rb",
     "lib/jazz_money/rspec_thread.rb",
     "lib/jazz_money/jasmine_runner.rb",
  ]

  s.add_dependency 'harmony', '0.5.4'
  s.add_dependency 'jasmine', '1.0.0.rc1'
end
