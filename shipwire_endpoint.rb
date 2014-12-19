require "sinatra"
require "endpoint_base"

require File.expand_path(File.dirname(__FILE__) + '/lib/ship_wire.rb')
Dir['./lib/**/*.rb'].each { |f| require f }

class ShipwireEndpoint < EndpointBase::Sinatra::Base
  endpoint_key ENV["ENDPOINT_KEY"]

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end if ENV['HONEYBADGER_KEY'].present?

  set :logging, true

  post '/add_shipment' do
    begin
      shipment_entry = ShipmentEntry.new(@payload, @config)
      response  = shipment_entry.consume

      result 200, 'Successfully sent shipment to Shipwire'
    rescue => e
      result 500, e.message
    end
  end

  post '/get_shipments' do
    begin
      shipment_tracking = ShipmentTracking.new(@payload, @config)
      response = shipment_tracking.consume

      if messages = response[:messages]
        messages.each { |m| add_object :shipment, m }
        set_summary "Successfully received #{messages.count} shipment(s) from Shipwire"
      end

      result 200
    rescue => e
      result 500, e.message
    end
  end

  post '/get_inventory' do
    begin

      stock = InventoryStatus.new(@payload, @config)

      code, response = stock.consume

      puts(code)
      puts(response)

      result 200, 'Successfully received Inventory from Shipwire'
    rescue => e
      puts(e.inspect)
      result 500, e.message
    end
  end

end
