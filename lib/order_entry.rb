# a ShipWire.Order.Id is the Spree.Order.Shipment.Number
class OrderEntry < ShipWire
  # register Keys::AUGURY_ORDER_NEW

  attr_reader :order

  def consume
    @order = Order.new(payload['order']['actual'], payload['shipment_number'])

    response = self.class.post('/FulfillmentServices.php', :body => xml_body)

    if response['SubmitOrderResponse']['Status'] == 'Error'
      return [ 500, { 'message_id' => message_id,
               'order_number' => order.number,
               'code' => 500,
               'shipwire_response' => response['SubmitOrderResponse'] } ]

    else
      return [ 200, { 'message_id' => message_id,
               'order_number' => order.number,
               'code' => 200,
               'shipwire_response' => response['SubmitOrderResponse'] } ]
    end
  end

  private

  def xml_body
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.OrderList {
        xml.Username config[:username]
        xml.Password config[:password]
        xml.Server server_mode
        xml.Referer 'SPREE'
        xml.Order(:id => order.shipment_number) {
          xml.Warehouse '00'
          xml.SameDay 'NOT REQUESTED'
          xml.Shipping 'GD'
          xml.AddressInfo(:type => 'ship') {
            xml.Name {
              xml.Full order.ship_full_name
            }
            xml.Phone order.ship_address['phone']
            xml.Email order.email
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
