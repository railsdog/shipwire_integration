Dir["./spec/support/**/*.rb"].each {|f| require f}

# The Order id we use to track is the Spree Shipment Number
#
# The <Bookmark> tag currently has three options:
# “1″ for a dump of everything in the account
# “2″ for a dump of everything since the last bookmark
# “3″ for a dump of everything since the last bookmark AND reset the bookmark to right now
class ShipmentTracking < ShipWire

  def consume
    # response = self.class.post('/TrackingServices.php', :body => xml_body)
    response = Factories.success_shipment_tracking_response

    if response['TrackingUpdateResponse']['Status'] == 'Error'
      raise SendError, response['TrackingUpdateResponse']['ErrorMessage']
    else
      msgs = []

      response['TrackingUpdateResponse']['Order'].each do |shipment|
        next unless shipment['shipped'] == 'YES'
        msgs << create_message(shipment)
      end

      return { 'messages' => msgs, 'shipwire_response' => response['TrackingUpdateResponse'] }
    end
  end

  private

  def create_message(shipment)
    {
      message: 'shipment:confirm',
      inflate: true,
      payload: {
        order: {},
        shipment: {
          number: shipment['id'].split(/-/).last,
          order_number: shipment['id'].split(/-/).first,
          tracking: shipment['TrackingNumber']['#text'],
          tracking_url: shipment['TrackingNumber']['href'],
          carrier: shipment['TrackingNumber']['carrier'],
          shipped_date: Time.parse(shipment['shipDate']).utc.to_s,
          delivery_date: Time.parse(shipment['expectedDeliveryDate']).utc.to_s
        }
      }
    }
  end

  def xml_body
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.TrackingUpdate {
        xml.Username config['username']
        xml.Password config['password']
        xml.Server server_mode
        xml.Bookmark '2'
      }
    end
    builder.to_xml
  end

end