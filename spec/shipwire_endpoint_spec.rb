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
    ShipmentEntry.should_receive(:new).with(params, anything).and_return(double(:consume => {}))
    post '/add_shipment', params.to_json, auth

    expect(last_response.status).to eq 200
  end

  it "should respond to POST /tracking" do
    params = { 'parameters' => parameters }
    ShipmentTracking.should_receive(:new).with(params, anything).and_return(double(:consume => {}))
    post '/get_shipments', params.to_json, auth
  end

  it "should respond to POST /send_shipment" do
    ShipmentEntry.should_receive(:new).with(params, anything).and_return(double(:consume => {}))
    post '/add_shipment', params.to_json, auth

    expect(last_response.status).to eq 200
  end

  it "should respond to POST /get_inventory", :rest => true do
    # InventoryStatus.should_receive(:new).with(params, anything).and_return(double(:consume => {}))
    VCR.use_cassette("inventory_item/new_search", :record => :all, :allow_playback_repeats => true) do
      post '/get_inventory', params.to_json, auth

      puts last_response.inspect

      expect(last_response.status).to eq 200
      expect(last_response.body).to be

      puts json_response.inspect

      expect(json_response[:products]).to be_present
      expect(json_response[:summary]).to be_present


    end
  end

  it "should respond with 500 to bad params on POST /get_inventory", :rest => true do
    # InventoryStatus.should_receive(:new).with(params, anything).and_return(double(:consume => {}))
    VCR.use_cassette("inventory_item/new_search", :record => :all, :allow_playback_repeats => true) do

      params["parameters"]["shipwire_username"] = "wotaloadof@rubbish.naff"

      puts  params["parameters"].inspect

      post '/get_inventory', params.to_json, auth

      puts last_response.inspect

      expect(last_response.status).to eq 500
      expect(last_response.body).to include "Error accessing stock information from Shipwire"
    end
  end

end
