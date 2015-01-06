require 'net/https'

class InventoryStatus < ShipWire

  def consume
    response = self.class.post('/exec/InventoryServices.php', :body => xml_body)

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


  def stock

    response = HTTParty.get("#{server}/api/v3/stock", { :basic_auth => basic_auth } )

    if response.code != 200
      puts response.body, response.code, response.message, response.headers.inspect,response.parsed_response.inspect

      return [ 500, { 'code' => 500,
                      'shipwire_response' => response.parsed_response['message'] } ]

    else
      msgs = []

      response.parsed_response['resource']['items'].each do |item|
        msgs << create_message(item['resource'])
      end

      return [ 200, {  'code' => 200,
                       'messages' => msgs,
                       'shipwire_response' => response.parsed_response } ]
    end
  end


  private

  def create_message(product)
    puts product.inspect
    {
        id: product['productId'],
        sku: product['sku'],
        count: product['good']
    }
  end


  def xml_body
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
