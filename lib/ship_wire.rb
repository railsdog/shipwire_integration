require 'nokogiri'

class ShipWire
  include HTTParty
  base_uri 'https://api.shipwire.com/exec/'
  format :xml

  attr_accessor :order, :api_key, :config, :message_id, :payload

  def initialize(payload, message_id, config={})
    @payload = payload
    @message_id = message_id
    @config = config

    authenticate!
  end

  def authenticate!
    raise AuthenticationError if @config['username'].nil? || @config['password'].nil?
  end

  def server_mode
    # Augury.test? ? 'Test' : 'Production'
    ENV['SHIPWIRE_ENDPOINT_SERVER_MODE']
  end

end

class AuthenticationError < StandardError; end
class ShipWireSubmitOrderError < StandardError; end
