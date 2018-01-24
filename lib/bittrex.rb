require "bittrex/version"
require "bittrex/exceptions"
require "active_support/core_ext/hash"

module Bittrex
  autoload :Helpers,       "bittrex/helpers"
  autoload :Market,        "bittrex/market"
  autoload :Client,        "bittrex/client"
  autoload :Configuration, "bittrex/configuration"
  autoload :Currency,      "bittrex/currency"
  autoload :Deposit,       "bittrex/deposit"
  autoload :Order,         "bittrex/order"
  autoload :Quote,         "bittrex/quote"
  autoload :Summary,       "bittrex/summary"
  autoload :Wallet,        "bittrex/wallet"
  autoload :Withdrawal,    "bittrex/withdrawal"

  def self.client
    @client ||= Client.new(configuration.auth)
  end

  def self.config
    yield configuration
    @client = Client.new(configuration.auth)
  end

  def self.configuration
    Configuration.instance
  end

  def self.root
    File.expand_path("../..", __FILE__)
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
