require 'spec_helper'

describe OrderTracking do
  let(:config) { { 'username' => 'chris@spreecommerce.com', 'password' => 'GBb4gv6wCjVeHV', 'order_tracking_bookmark' => 1 } }

  subject { described_class.new({}, 'a123', config) }

  it 'posts to the TrackingServices api' do
    VCR.use_cassette('ship_wire_order_tracking') do
      response = subject.consume
      response['messages'].size.should == 2
      response['shipwire_response'].should have_key('Order')
      response['shipwire_response']['Order'].size == 3 #one not shipped
    end
  end

  it 'builds xml body' do
    xml = subject.send :xml_body
    xml.should match '<Username>chris@spreecommerce.com</Username>'
  end

end
