module Bittrex
  class Withdrawal

    include Helpers

    attr_reader :id, :currency, :quantity, :address, :authorized,
                :pending, :canceled, :invalid_address,
                :transaction_cost, :transaction_id, :executed_at

    def initialize(attrs = {})
      @id = attrs["PaymentUuid"]
      @currency = attrs["Currency"]
      @quantity = attrs["Amount"]
      @address = attrs["Address"]
      @authorized = attrs["Authorized"]
      @pending = attrs["PendingPayment"]
      @canceled = attrs["Canceled"]
      @invalid_address = attrs["Canceled"]
      @transaction_cost = attrs["TxCost"]
      @transaction_id = attrs["TxId"]
      @executed_at = extract_timestamp(attrs["Opened"])
    end

    def self.history
      client.get("account/getwithdrawalhistory").map { |data| new(data) }
    end

    def self.withdraw(currency:, quantity:, address:, paymentid: nil)
      params = 
        {
          currency: currency,
          quantity: quantity,
          address: address,
          paymentid: paymentid,
        }

      client.get("account/withdraw", params)
    end

    def self.client
      @client ||= Bittrex.client
    end

  end
end
