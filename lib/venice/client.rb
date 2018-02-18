require 'json'
require 'net/https'
require 'uri'

module Venice
  APPSTORE_PROD_ENDPOINT = 'https://buy.itunes.apple.com/verifyReceipt'.freeze
  APPSTORE_DEV_ENDPOINT = 'https://sandbox.itunes.apple.com/verifyReceipt'.freeze

  class Client

    class NoVerificationEndpointError < StandardError; end

    attr_accessor :verification_url
    attr_writer :shared_secret
    attr_writer :exclude_old_transactions

    class << self
      def development
        client = new
        client.verification_url = APPSTORE_DEV_ENDPOINT
        client
      end

      def production
        client = new
        client.verification_url = APPSTORE_PROD_ENDPOINT
        client
      end
    end

    def initialize
      @verification_url = ENV['IAP_VERIFICATION_ENDPOINT']
      @shared_secret = ENV['IAP_SHARED_SECRET']
    end

    def verify(data, options = {})
      verify!(data, options)
    rescue Venice::VerificationError, Client::TimeoutError
      false
    end

    def verify!(data, options = {})
      client = Client.production

      begin
        response_from_verifying_data!(data, options)
      rescue Venice::VerificationError => error
        case error.code
        when 21007
          client = Client.development
          retry
        when 21008
          client = Client.production
          retry
        else
          raise error
        end
      end
    end
    alias :validate :verify
    alias :validate! :verify!

    private

    def response_from_verifying_data!(data, options = {})
      raise NoVerificationEndpointError if @verification_url.to_s.empty?

      parameters = {
        'receipt-data': data
      }

      shared_secret = options[:shared_secret]
      parameters['password'] = shared_secret if shared_secret

      exclude_old = options[:exclude_old_transactions]
      parameters['exclude-old-transactions'] = exclude_old if exclude_old

      uri = URI(@verification_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      http.open_timeout = options[:open_timeout] if options[:open_timeout]
      http.read_timeout = options[:read_timeout] if options[:read_timeout]

      request = Net::HTTP::Post.new(uri.request_uri)
      request['Accept'] = 'application/json'
      request['Content-Type'] = 'application/json'
      request.body = parameters.to_json

      begin
        response = http.request(request)
      rescue Timeout::Error
        raise TimeoutError
      end

      json = JSON.parse(response.body)

      puts ""
      puts "Venice::Client.json_response_from_verifying_data json: #{json.inspect}"
      puts ""

      response = ItcVerificationResponse.new(json)

      puts ""
      puts "Venice::Client.json_response_from_verifying_data response: #{response.inspect}"
      puts ""

      response
    end
  end

  class Client::TimeoutError < Timeout::Error
    def message
      'The App Store timed out.'
    end
  end
end
