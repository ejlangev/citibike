require 'citibike'

require 'rspec'
require 'rspec/autorun'

require 'vcr'
require 'yajl'

require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  config.mock_with :mocha
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :faraday
  c.allow_http_connections_when_no_cassette = true
end