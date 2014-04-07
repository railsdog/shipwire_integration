require "sinatra"
require "endpoint_base"

require File.expand_path(File.dirname(__FILE__) + '/lib/ship_wire.rb')
Dir['./lib/**/*.rb'].each { |f| require f }

class ShipwireEndpoint < EndpointBase::Sinatra::Base
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

  # Track shipment dispatches. Previously triggered with shipwire:shipment_results:poll.
  # Returns a collection of shipment:confirm messages
  #
  # TODO How to trigger now?
  post '/get_shipments' do
    begin
      shipment_tracking = ShipmentTracking.new(@payload, @config)
      response = shipment_tracking.consume

      response[:messages].each do |message|
        add_object :shipment, message
      end

      result 200, 'Successfully sent shipment tracking information to shipwire'
    rescue => e
      result 500, e.message
    end
  end
end
