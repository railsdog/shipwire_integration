class InventoryStatus < ShipWire

  def consume
    response = self.class.post('/InventoryServices.php', :body => xml_body)

    if response['InventoryUpdateResponse']['Status'] == 'Error'
      return [ 500, { 'message_id' => message_id,
               'code' => 500,
               'shipwire_response' => response['InventoryUpdateResponse'] } ]

    else
      return [ 200, { 'message_id' => message_id,
               'code' => 200,
               'shipwire_response' => response['InventoryUpdateResponse'] } ]

    end
  end

  private

  def xml_body
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.InventoryUpdate {
        xml.Username config['username']
        xml.Password config['password']
        xml.Server server_mode
      }
    end
    builder.to_xml
  end

end
