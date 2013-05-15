class Order
  attr_reader :shipment, :shipment_number

  def initialize(order_hash={}, shipment_number=nil)
    @order_hash = order_hash
    if @order_hash.key?('order')
      @order_hash = @order_hash['order']
    end

    @shipment_number = shipment_number

    @shipment = @order_hash['shipments'].detect do |shipment|
      shipment = shipment['shipment'] if shipment.key?('shipment')
      shipment['number'] == @shipment_number
    end

    if @shipment && @shipment.key?('shipment')
      @shipment = @shipment['shipment']
    end

    validate!
  end

  def validate!
    raise 'order number required' unless number
    raise 'shipment number required' unless shipment_number
    validate_address!(ship_address)
  end

  def validate_address!(address)
    raise 'address1 required' unless address['address1']
    raise 'city required' unless address['city']
    raise 'country required' unless address['country']['iso']
    raise 'zipcode required' unless address['zipcode']
  end

  def number
    @order_hash['number']
  end

  def email
    @order_hash['email']
  end

  def ship_address
    @order_hash['ship_address']
  end

  def ship_state
    ship_address['state']['abbr']
  end

  def ship_country
    ship_address['country']['iso']
  end

  def ship_full_name
    "#{ship_address['firstname']} #{ship_address['lastname']}"
  end

  def shipment_items
    units = @shipment['inventory_units'].map do |inventory_unit|
      inventory_unit.key?('inventory_unit') ? inventory_unit['inventory_unit'] : inventory_unit
    end

    units.group_by { |unit| unit['variant_id'] }
  end

  def variant_sku(variant_id)
    @variants ||= @order_hash['line_items'].map do |line_item|
      line_item = line_item['line_item'] if line_item.key?('line_item')
      line_item['variant']
    end

    @variants.detect { |v| v['id'] == variant_id }['sku']
  end

end
