require 'nokogiri'

class ShipWire
  include HTTParty
  base_uri 'https://api.shipwire.com/exec/'
  format :xml

  attr_accessor :order, :api_key, :config, :message_id, :payload

  def initialize(payload, message_id, config={})
    @payload = payload
    @config = config
    @message_id = message_id
    raise AuthenticationError if @config[:username].nil? || @config[:password].nil?
  end

  def server_mode
    # Augury.test? ? 'Test' : 'Production'
    ENV['SHIPWIRE_ENDPOINT_SERVER_MODE']
  end

  class AuthenticationError < StandardError; end
end
