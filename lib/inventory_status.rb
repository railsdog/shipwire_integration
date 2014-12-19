class InventoryStatus < ShipWire
  def consume
    puts "InventoryStatus::consume"

    response = self.class.post('/InventoryServices.php', :body => xml_body)

    if response['InventoryUpdateResponse']['Status'] == 'Error'
      return [ 500, {
               'code' => 500,
               'shipwire_response' => response['InventoryUpdateResponse'] } ]

    else
      return [ 200, {
               'code' => 200,
               'shipwire_response' => response['InventoryUpdateResponse'] } ]

    end
  end

  private

  def xml_body
    puts "Build  XML #{config.inspect} "
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.InventoryUpdate {
        xml.Username config['shipwire_username']
        xml.Password config['shipwire_password']
        xml.Server server_mode
      }
    end
    builder.to_xml
  end
end
