require "uri"
require "net/http"
require "rainbow/ext/string"

module Blade
  class Coin
    def initialize(input)
      @coin = input
      query_for_hash
    end

    def query_for_hash
      query_url = get_mxc_single_market(@coin)
      result_json  = Net::HTTP.get(URI(query_url))
      @result_hash = JSON.parse(result_json)
    end

    def get_mxc_single_market(coin)
      "https://www.mexc.com/open/api/v2/market/ticker?symbol=#{coin}_USDT"
    end

    def usdt_result
      return [] unless @result_hash["data"]
      lines = []
      data = @result_hash["data"][0]
      lines << data["symbol"].color(:red)
      lines << data["last"].color(:green)
      lines << ""
    end

    def result
      output = []
      output << usdt_result
      output.flatten
    end
  end
end
