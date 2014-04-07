require 'spec_helper'

describe ShipwireEndpoint do
  let(:parameters) do
    {
      'shipwire_username' => 'chris@spreecommerce.com',
      'shipwire_password' => 'GBb4gv6wCjVeHV',
      'shipment_tracking_bookmark' => 1
    }
  end

  let(:params) do
    Factories.payload.merge('parameters' => parameters)
  end

  it "should respond to POST /send_shipment" do
    ShipmentEntry.should_receive(:new).with(params, anything).and_return(mock(:consume => {}))
    post '/send_shipment', params.to_json, auth

    last_response.status.should eq 200
  end

  it "should respond to POST /tracking" do
    params = { 'parameters' => parameters }
    ShipmentTracking.should_receive(:new).with(params, anything).and_return(mock(:consume => {}))
    post '/tracking', params.to_json, auth
  end
end
