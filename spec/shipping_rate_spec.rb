require 'spec_helper'

describe ShippingRate do
  let(:config) { { 'username' => 'chris@spreecommerce.com', 'password' => 'GBb4gv6wCjVeHV', 'order_tracking_bookmark' => 1 } }
  let(:payload) { Factories.payload }

  subject { described_class.new(payload, 'a123', config) }

  it 'posts to the raterservices api' do
    VCR.use_cassette('ship_wire_shipping_rate') do
      expect {
        code, response = subject.consume

        code.should == 200

        response['shipwire_response']['Order'].should have_key('Quotes')
      }.to_not raise_error
    end
  end

  it 'builds xml body' do
    subject.stub(:order => Order.new(payload['shipment']))
    xml = subject.send :xml_body
    xml.should match '<Username>chris@spreecommerce.com</Username>'
    xml.should match '<State>Maryland</State>'
    xml.should match '<Item num="0">'
    xml.should match '<Code>SPR-00001</Code>'
  end

end
