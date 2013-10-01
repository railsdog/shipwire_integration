require 'spec_helper'

describe ShipmentEntry do
  let(:config) { { 'username' => 'chris@spreecommerce.com', 'password' => 'GBb4gv6wCjVeHV', 'order_tracking_bookmark' => 1 } }
  let(:payload) { Factories.payload }

  subject { described_class.new(payload, 'a123', config) }

  it 'posts to the FulfillmentServices api' do
    VCR.use_cassette('ship_wire_shipment_entry') do
      expect {
        response = subject.consume
        response['shipwire_response'].should have_key('TransactionId')
      }.to_not raise_error
    end
  end

  it 'handles failure responses' do
    subject.class.should_receive(:post).and_return({'SubmitOrderResponse' => { 'Status' => 'Error' }})
    expect {
      response = subject.consume
      response.should have_key('shipwire_response')
      response['shipwire_response'].should_not have_key('TransactionId')
      response['shipwire_response'].should have_key('Status')
    }.to raise_error ShipWireSubmitOrderError
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
