require 'rubygems'
require 'bundler'
require 'dotenv'
Dotenv.load

Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '..', 'shipwire_endpoint.rb')
Dir["./spec/support/**/*.rb"].each {|f| require f}

require 'spree/testing_support/controllers'

Sinatra::Base.environment = 'test'

def app
  ShipwireEndpoint
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end

VCR.configure do |c|
  #c.allow_http_connections_when_no_cassette = false
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock

  c.filter_sensitive_data("NETSUITE_EMAIL")    { ENV["NETSUITE_EMAIL"] }
  c.filter_sensitive_data("NETSUITE_PASSWORD") { ENV["NETSUITE_PASSWORD"] }
  c.filter_sensitive_data("NETSUITE_ACCOUNT")  { ENV["NETSUITE_ACCOUNT"] }
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Spree::TestingSupport::Controllers
end

ENV['ENDPOINT_KEY'] = 'x123'
ENV['SHIPWIRE_ENDPOINT_SERVER_MODE'] = 'Test'


