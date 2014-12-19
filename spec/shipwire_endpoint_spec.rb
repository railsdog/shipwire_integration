require 'spec_helper'

describe ShipwireEndpoint do
  let(:parameters) do
    {
        'shipwire_username' => ENV['SHIPWIRE_USERNAME'],
        'shipwire_password' => ENV['SHIPWIRE_PASSWORD'],
        'shipment_tracking_bookmark' => 1
    }
  end

  let(:params) do
    Factories.payload.merge('parameters' => parameters)
  end

  it "should respond to POST /send_shipment" do
    ShipmentEntry.should_receive(:new).with(params, anything).and_return(mock(:consume => {}))
    post '/add_shipment', params.to_json, auth

    last_response.status.should eq 200
  end

  it "should respond to POST /tracking" do
    params = { 'parameters' => parameters }
    ShipmentTracking.should_receive(:new).with(params, anything).and_return(mock(:consume => {}))
    post '/get_shipments', params.to_json, auth
  end

  it "should respond to POST /send_shipment" do
    ShipmentEntry.should_receive(:new).with(params, anything).and_return(mock(:consume => {}))
    post '/add_shipment', params.to_json, auth

    last_response.status.should eq 200
  end

  it "should respond to POST /get_inventory", :debug => true do
    # InventoryStatus.should_receive(:new).with(params, anything).and_return(mock(:consume => {}))
    VCR.use_cassette("inventory_item/new_search", :record => :all, :allow_playback_repeats => true) do
      post '/get_inventory', params.to_json, auth

      last_response.status.should eq 200
    end
  end


end
