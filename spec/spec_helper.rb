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

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Spree::TestingSupport::Controllers
end

ENV['ENDPOINT_KEY'] = 'x123'
ENV['SHIPWIRE_ENDPOINT_SERVER_MODE'] = 'Test'
