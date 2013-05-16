require File.expand_path(File.dirname(__FILE__) + '/lib/ship_wire.rb')
Dir['./lib/**/*.rb'].each { |f| require f }

class ShipwireEndpoint < EndpointBase
  set :logging, true

  post '/order' do
    order_entry = OrderEntry.new(@message[:payload], @message[:message_id], @config)
    process_result *order_entry.consume
  end

  post '/tracking' do
    order_tracking = OrderTracking.new(@message[:payload], @message[:message_id], @config)
    process_result *order_entry.consume
  end

end
