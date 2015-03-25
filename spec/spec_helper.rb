$: << File.join(File.dirname(__FILE__), "/../lib")

require 'accessibility'
require 'webmock/rspec'

def fixture_file(filename)
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end
