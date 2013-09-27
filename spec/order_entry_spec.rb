require 'spec_helper'

describe OrderEntry do
  let(:config) { { 'username' => 'chris@spreecommerce.com', 'password' => 'GBb4gv6wCjVeHV', 'order_tracking_bookmark' => 1 } }
  let(:payload) { Factories.payload }

  subject { described_class.new(payload, 'a123', config) }

  it 'posts to the FulfillmentServices api' do
    VCR.use_cassette('ship_wire_order_entry') do
      expect {
        code, response = subject.consume
        code.should == 200
        response['shipwire_response'].should have_key('TransactionId')
      }.to_not raise_error
    end
  end

  it 'handles failure responses' do
    subject.class.should_receive(:post).and_return({'SubmitOrderResponse' => { 'Status' => 'Error' }})
    code, response = subject.consume
    code.should == 500
    response['shipwire_response'].should_not have_key('TransactionId')
    response['shipwire_response'].should have_key('Status')
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
