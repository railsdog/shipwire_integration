# a ShipWire.Order.Id is the Spree.Order.Shipment.Number
class ShippingRate < ShipWire

  attr_reader :order

  def consume
    @order = Order.new(payload['order']['actual'], payload['shipment_number'])

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
        xml.Username config[:username]
        xml.Password config[:password]
        xml.Server server_mode
        xml.Order(:id => order.shipment_number) {
          xml.Warehouse '00'
          xml.AddressInfo(:type => 'ship') {
            xml.Address1 order.ship_address['address1']
            xml.Address2 order.ship_address['address2']
            xml.City order.ship_address['city']
            xml.State order.ship_state
            xml.Country order.ship_country
            xml.Zip order.ship_address['zipcode']
          }


          order.shipment_items.each_with_index do |(variant_id, units), index|
            xml.Item(:num => index) {
              xml.Code order.variant_sku(variant_id)
              xml.Quantity units.size
            }
          end
        }
      }
    end
    builder.to_xml
  end

end
