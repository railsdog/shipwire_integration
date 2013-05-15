require 'spec_helper'

describe ShipWireEndpoint do

  def auth
    {'HTTP_X_AUGURY_TOKEN' => 'x123'}
  end

  def app
    described_class
  end

  let(:params) { {'store_id' => '123229227575e4645c000001',
                  'payload' => { 'order' => { 'actual' => Factories.order },
                                 'parameters' => {
                                    'username' => 'chris@spreecommerce.com',
                                    'password' => 'GBb4gv6wCjVeHV',
                                    'order_tracking_bookmark' => 1 },
                                 'shipment_number' => 'H438105531460' },
                  'message_id' => 'abc'  } }

  it "should respond to POST /order" do
    OrderEntry.should_receive(:new).with(params['payload'], params['message_id'], anything).and_return(mock(:consume => {}))
    post '/order', params.to_json, auth
  end

  it "should respond to POST /tracking" do
    params['payload'] = {}

    OrderTracking.should_receive(:new).with(params['payload'], params['message_id'], anything).and_return(mock(:consume => {}))
    post '/tracking', params.to_json, auth
  end
end

