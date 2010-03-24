require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe JazzMoney::JasmineRunner do

  before do
    @page = Harmony::Page.new
    @observer = Object.new
  end

  it "notifies the given observer of the top-level spec results" do
    mock_observer
    jasmine_spec_file = fixture_file('success.js')
    runner = JazzMoney::JasmineRunner.new(@page, [jasmine_spec_file], [], @observer)

    runner.start
    runner.wait

    JSON.parse(@received_results)["result"].should == "passed"
  end

  it "notifies the given observer with one message per expectation" do
    mock_observer
    jasmine_spec_file = fixture_file('failure.js')
    runner = JazzMoney::JasmineRunner.new(@page, [jasmine_spec_file], [], @observer)

    runner.start
    runner.wait

    JSON.parse(@received_results)["messages"].size.should == 2
    JSON.parse(@received_results)["messages"][0]["message"].should == "Passed."
    JSON.parse(@received_results)["messages"][0]["stack_trace"].should be_nil
    JSON.parse(@received_results)["messages"][1]["message"].should include("to equal 20")
    JSON.parse(@received_results)["messages"][1]["stack_trace"].should include("spec/fixtures/failure.js")    
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

  it "works even if jasmine hands us spec results have a non-json'able object in them" do
    mock_observer
    jasmine_spec_file = fixture_file('spec_with_unserializable_object.js')
    runner = JazzMoney::JasmineRunner.new(@page, [jasmine_spec_file], [], @observer, html_fixture_dir)

    runner.start
    runner.wait

    JSON.parse(@received_results)["result"].should == "failed"
    JSON.parse(@received_results)["messages"][0]["message"].should == "Expected HTMLNode to equal HTMLNode."
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
