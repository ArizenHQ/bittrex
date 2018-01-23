require "rest-client"
require "base64"
require "json"

module Bittrex
  class Client

    API_ENDPOINT = "https://bittrex.com/api/".freeze
    API_VERSION = "v1.1/".freeze
    HOST = (API_ENDPOINT + API_VERSION).freeze

    attr_reader :key, :secret

    def initialize(attrs = {})
      @key    = attrs[:key]
      @secret = attrs[:secret]
    end

    def get(path, params = {}, headers = {})
      nonce = Time.now.to_i

      params.merge!({ apikey: key, nonce: nonce }).compact!
      uri = build_url(path, params)

      response = execute(uri, headers)
      response = JSON.parse(response.body)

      raise ::Bittrex::APIError, response["message"] unless response["success"]

      response["result"]
    end

    private

    def build_url(path, params)
      uri = URI.join(HOST, path)
      query_params = URI.encode_www_form(params)
      uri.query = query_params

      uri.to_s
    end

    def execute(uri, headers)
      headers.merge!({ apisign: signature(uri) }) if key

      RestClient.get(uri, headers)
    end

    def signature(uri)
      OpenSSL::HMAC.hexdigest("sha512", secret, uri)
    end

  end
end
