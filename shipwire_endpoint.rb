require "sinatra"
require "endpoint_base"

require File.expand_path(File.dirname(__FILE__) + '/lib/ship_wire.rb')
Dir['./lib/**/*.rb'].each { |f| require f }

class ShipwireEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/send_shipment' do
    begin
  	  shipment_entry = ShipmentEntry.new(@payload, @config)
  	  response  = shipment_entry.consume

  	  msg = success_shipment_notification(response)
  	  code = 200
    rescue => e
      msg = error_notification(e)
      code = 500
    end

    process_result code, msg
  end

  post '/tracking' do
    begin
      shipment_tracking = ShipmentTracking.new(@payload, @config)
      response = shipment_tracking.consume

      msg = success_tracking_notification(response)
      code = 200
    rescue => e
      msg = error_notification(e)
      code = 500
    end

    process_result code, msg
  end

  private
  def success_shipment_notification(response)
    { notifications:
      [
      	{ level: 'info',
          subject: 'Successfully sent shipment to Shipwire',
          description: 'Successfully sent shipment to Shipwire' }
      ]
    }.merge(response)
  end

  def success_tracking_notification(response)
    { notifications:
      [
      	{ level: 'info',
          subject: 'Successfully sent shipment tracking information to shipwire',
          description: 'Successfully sent shipment tracking information to shipwire' }
      ]
    }.merge(response)
  end

  def error_notification(e)
    { notifications:
      [
      	{
          level: 'error',
          subject: e.message.strip,
          description: e.message.strip,
          backtrace: e.backtrace.to_a.join('\n\t')
        }
      ]
    }
  end
end
