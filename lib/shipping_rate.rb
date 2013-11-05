# a ShipWire.Order.Id is the Spree.Order.Shipment.Number
class ShippingRate < ShipWire

  attr_reader :order

  def consume
    @order = Order.new(payload['shipment'])

    response = self.class.post('/RateServices.php', :body => xml_body)

    if response['RateResponse']['Status'] == 'OK'
      # response['RateResponse']['Order']

      return [ 200, { 'message_id' => message_id,
               'order_number' => order.number,
               'code' => 200,
               'shipwire_response' => response['RateResponse'] } ]
    else

      return [ 500, { 'message_id' => message_id,
               'order_number' => order.number,
               'code' => 500,
               'shipwire_response' => response['RateResponse'] } ]

    end
  end

  private

  #TODO: Make it multi-shipment aware
  def xml_body
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.RateRequest {
        xml.Username config['shipwire.username']
        xml.Password config['shipwire.password']
        xml.Server server_mode
        xml.Order(:id => order.shipment_number) {
          xml.Warehouse '00'
          xml.AddressInfo(:type => 'ship') {
            xml.Address1 order.shipping_address['address1']
            xml.Address2 order.shipping_address['address2']
            xml.City order.shipping_address['city']
            xml.State order.shipping_state
            xml.Country order.shipping_country
            xml.Zip order.shipping_address['zipcode']
          }

          order.shipment_items.each_with_index do |unit, index|
            xml.Item(:num => index) {
              xml.Code order.variant_sku(unit['variant_id'])
              xml.Quantity unit['quantity']
            }
          end
        }
      }
    end
    builder.to_xml
  end

end
