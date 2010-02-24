$LOAD_PATH << File.join(File.dirname(__FILE__), '../lib')

require 'rubygems'

require File.expand_path(File.dirname(__FILE__) + '/../lib/jazz_money')

require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.mock_with :rr
end