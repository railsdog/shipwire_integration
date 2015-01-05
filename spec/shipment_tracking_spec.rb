require 'spec_helper'

describe ShipmentTracking do
  let(:config) do
    {
        'shipwire_username' => ENV['SHIPWIRE_USERNAME'],
        'shipwire_password' => ENV['SHIPWIRE_PASSWORD'],
        'shipment_tracking_bookmark' => 1
    }
  end

  subject { described_class.new({}, config) }

  it 'posts to the TrackingServices api' do
    VCR.use_cassette('ship_wire_shipment_tracking') do
      response = subject.consume
      response['messages'].size.should == 2
      response['shipwire_response'].should have_key('Order')
      response['shipwire_response']['Order'].size == 3 #one not shipped
    end
  end

  it 'builds xml body' do
    xml = subject.send :xml_body
    expect(xml).to include "<Username>" + ENV['SHIPWIRE_USERNAME'] + "</Username>"
  end
end
