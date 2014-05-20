class Order
  attr_reader :shipment,
              :shipment_number,
              :order_number

  def initialize(shipment_hash={})
    @shipment = shipment_hash
    @shipment_number = shipment['id'] || shipment['number']
    @order_number = shipment['order_id']

    validate!
    validate_address!
  end

  def validate!
    raise 'order number required' unless number
    raise 'shipment number required' unless shipment_number
  end

  def validate_address!
    raise 'address1 required' unless shipping_address1
    raise 'city required' unless shipping_city
    raise 'country required' unless shipping_country
    raise 'zipcode required' unless shipping_zipcode
  end

  def number
    shipment['id'] || shipment['number']
  end

  def email
    shipment['email']
  end

  def shipping_address
    shipment['shipping_address']
  end

  def shipping_address1
    shipping_address['address1']
  end

  def shipping_city
    shipping_address['city']
  end

  def shipping_state
    shipping_address['state']
  end

  def shipping_country
    shipping_address['country']
  end

  def shipping_zipcode
    shipping_address['zipcode']
  end

  def shipping_full_name
    "#{shipping_address['firstname']} #{shipping_address['lastname']}"
  end

  def shipment_items
    shipment['items']
  end

  def variant_sku(variant_id)
    shipment_items.detect { |v| v['variant_id'] == variant_id }['sku']
  end
end
