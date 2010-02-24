require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe JazzMoney::JasmineRunner do

  before do
    @page = Harmony::Page.new
    @observer = Object.new
  end

  it "runs jasmine specs and registers the given reporter to observe results" do
    mock_observer
    jasmine_spec_file = fixture_file('success.js')
    runner = JazzMoney::JasmineRunner.new(@page, [jasmine_spec_file], [], @observer)

    runner.start
    runner.wait

    JSON.parse(@received_results)["result"].should == "passed"
    JSON.parse(@received_results)["messages"].size.should == 1
  end

  it "loads js includes so the specs can depend on them" do
    mock_observer
    jasmine_spec_file = fixture_file('spec_with_dependency.js')
    dependency_to_include = fixture_file('dependency.js')
    runner = JazzMoney::JasmineRunner.new(@page, [jasmine_spec_file], [dependency_to_include], @observer)

    runner.start
    runner.wait

    JSON.parse(@received_results)["result"].should == "passed"
  end

  it "loads HTML fixture data from a directory and makes a function available to load them" do
    mock_observer
    jasmine_spec_file = fixture_file('spec_with_fixture.js')
    runner = JazzMoney::JasmineRunner.new(@page, [jasmine_spec_file], [], @observer, html_fixture_dir)

    runner.start
    runner.wait
    
    JSON.parse(@received_results)["result"].should == "passed"
  end

  def mock_observer
    mock(@observer).report_spec_results(0, anything) do |spec_id, results|
      @received_results = results
    end
  end

  def html_fixture_dir
    File.expand_path(File.dirname(__FILE__) + '/fixtures/html_fixtures')
  end

  # get a fixture for *this test*. note that fixtures for this spec can be jasmine specs
  # and also HTML fixtures for those specs. meta as hell, i know.
  def fixture_file(name)
    File.expand_path(File.dirname(__FILE__) + '/fixtures/' + name)
  end

end
