module Bittrex
  class Wallet

    attr_reader :id, :currency, :balance, :available, :pending, :address, :requested, :raw

    def initialize(attrs = {})
      @id = attrs["Uuid"].to_s
      @address = attrs["CryptoAddress"]
      @currency = attrs["Currency"]
      @balance = attrs["Balance"]
      @available = attrs["Available"]
      @pending = attrs["Pending"]
      @raw = attrs
      @requested = attrs["Requested"]
    end

    def self.all
      data = client.get("account/getbalances")

      return unless data

      data.map { |wallet| new(wallet) }
    end

    def self.currency(currency)
      data = client.get("account/getbalance", currency: currency)

      return unless data

      new(data)
    end

    def self.client
      @client ||= Bittrex.client
    end

  end
end
