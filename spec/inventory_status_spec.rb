require 'spec_helper'

describe InventoryStatus do

  let(:config) do
    {
        'shipwire_username' => ENV['SHIPWIRE_USERNAME'],
        'shipwire_password' => ENV['SHIPWIRE_PASSWORD'],
        'shipment_tracking_bookmark' => 1
    }
  end

  subject { described_class.new({}, config) }

  context "deprecated XML API" do

    it 'posts to the InventoryServices XML api' do
      VCR.use_cassette('ship_wire_inventory_status', :record => :all, :allow_playback_repeats => true) do
        expect {
          code, response = subject.consume

          code.should == 200
          response['shipwire_response'].should have_key('Product')
        }.to_not raise_error
      end
    end

    it 'builds xml body' do
      xml = subject.send :xml_body
      xml.should match "<Username>#{ENV['SHIPWIRE_USERNAME']}</Username>"
      xml.should match "<Password>#{ENV['SHIPWIRE_PASSWORD']}</Password>"
    end

  end


  context "new REST API" do

    it 'posts to the InventoryServices REST api' do
      VCR.use_cassette('inventory/ship_wire_inventory_status', :record => :all, :allow_playback_repeats => true) do
        expect { code, response = subject.stock  }.to_not raise_error
      end
    end

    it 'returns suitable code and response' do
      VCR.use_cassette('inventory/ship_wire_inventory_status', :record => :all, :allow_playback_repeats => true) do

        code, response = subject.stock

        expect(code).to eq 200
        expect(response['shipwire_response']).to have_key('resource')
      end
    end

    it "builds out a collection of inventory units", :debug => true do
      VCR.use_cassette('inventory/ship_wire_stock', :record => :all, :allow_playback_repeats => true) do
        code, response = subject.stock

        puts response['shipwire_response']['resource'].inspect

        #response['shipwire_response']['resource'].each { |i| puts i}
      end
    end

  end

end
