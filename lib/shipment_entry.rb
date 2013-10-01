# a ShipWire.Order.Id is the Spree.Order.Shipment.Number
class ShipmentEntry < ShipWire
  # register Keys::AUGURY_ORDER_NEW

  attr_reader :order

  def consume
    @order = Order.new(payload['shipment'])

    response = self.class.post('/FulfillmentServices.php', :body => xml_body)

    if response['SubmitOrderResponse']['Status'] == 'Error'
      raise ShipWireSubmitOrderError, 'shipwire_response' => response['SubmitOrderResponse']
    end

    return { 'shipwire_response' => response['SubmitOrderResponse'] }
  end

  private

  def xml_body
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.OrderList {
        xml.Username config['username']
        xml.Password config['password']
        xml.Server server_mode
        xml.Referer 'SPREE'
        xml.Order(:id => order.shipment_number) {
          xml.Warehouse '00'
          xml.SameDay 'NOT REQUESTED'
          xml.Shipping 'GD'
          xml.AddressInfo(:type => 'ship') {
            xml.Name {
              xml.Full order.shipping_full_name
            }
            xml.Phone order.shipping_address['phone']
            xml.Email order.email
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
