require 'nokogiri'

class ShipWire

  include HTTParty
  base_uri(ENV['SHIPWIRE_BASE_URI'] || 'api.shipwire.com')
  format :xml

  attr_accessor :order, :api_key, :config, :payload

  def initialize(payload, config={})
    @payload = payload
    @config = config

    puts "ShipWire::initialize #{@config.inspect}"
    authenticate!
  end

  def authenticate!
    raise AuthenticationError if @config['shipwire_username'].nil? || @config['shipwire_password'].nil?
  end

  def server
    @server ||= (ENV['SHIPWIRE_BASE_URI'] || 'api.shipwire.com')
  end

  def basic_auth
    @basic_auth ||= {:username => @config['shipwire_username'], :password => @config['shipwire_password'] }
  end


  def server_mode
    # Augury.test? ? 'Test' : 'Production'
    (ENV['SHIPWIRE_ENDPOINT_SERVER_MODE'] || 'Test').capitalize
  end

end

class AuthenticationError < StandardError; end
class ShipWireSubmitOrderError < StandardError; end
class SendError < StandardError; end
