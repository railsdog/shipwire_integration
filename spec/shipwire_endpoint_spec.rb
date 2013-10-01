require 'spec_helper'

describe ShipwireEndpoint do

  def auth
    {'HTTP_X_AUGURY_TOKEN' => 'x123'}
  end

  let(:params) { {'store_id' => '123229227575e4645c000001',
                  'message_id' => 'abc',
                  'payload' => Factories.payload.merge(
                    'parameters' => 
                      [ { name: 'username', value: 'chris@spreecommerce.com' },
                      { name: 'password', value: 'GBb4gv6wCjVeHV' },
                      { name: 'order_tracking_bookmark', value: 1 } ] )
                  } }

  it "should respond to POST /send_shipment" do
    ShipmentEntry.should_receive(:new).with(params['payload'], params['message_id'], anything).and_return(mock(:consume => {}))

    post '/send_shipment', params.to_json, auth
    last_response.body.should include("notifications")
    last_response.body.should include("message_id")
    last_response.status.should eq 200
  end

  it "should respond to POST /tracking" do
    params['payload'] = {}

    OrderTracking.should_receive(:new).with(params['payload'], params['message_id'], anything).and_return(mock(:consume => {}))
    post '/tracking', params.to_json, auth
  end
end

