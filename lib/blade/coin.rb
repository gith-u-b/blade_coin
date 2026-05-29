require "uri"
require "net/http"
require "json"
require "rainbow/ext/string"
require "terminal-table"

module Blade
  class Coin
    def initialize(input)
      @coin = input
    end

    def query_for_hash
      query_url = get_mxc_single_market(@coin)
      raw = make_http_request(query_url)
      # Gate.io returns an array, wrap it to match the legacy MEXC format: { data: [...] }
      @result_hash = raw.is_a?(Array) ? { data: raw } : raw
    end

    def get_mxc_single_market(coin)
      "https://api.gateio.ws/api/v4/spot/tickers?currency_pair=#{coin.upcase}_USDT"
    end

    def get_top_markets(top = 10)
      query_url = "https://min-api.cryptocompare.com/data/top/mktcapfull?limit=#{top}&tsym=USD"
      result_json = make_http_request(query_url)
      raw_data = result_json[:Data]

      puts green_colorize("Data source from cryptocompare.com at #{Time.now.strftime('%I:%M:%S %p')}")

      data = raw_data.each_with_index.map do |item, i|
        coin = item[:CoinInfo]
        usd = item.dig(:RAW, :USD)
        next unless usd
        {
          rank: i + 1,
          symbol: coin[:Name],
          priceUsd: usd[:PRICE],
          changePercent24Hr: usd[:CHANGEPCT24HOUR],
          vwap24Hr: usd[:MEDIAN],
          marketCapUsd: usd[:MKTCAP]
        }
      end
      data.compact!

      display_market_data(data)
    end

    def display_market_data(data)
      title = '💰Wishing you prosperity and wealth(恭喜发财)💰'.color(226)
      table = Terminal::Table.new(title: "\e[33m#{title}\e[0m") do |t|
        t.headings = [orange_colorize('Rank'), orange_colorize('Coin'), orange_colorize('Price (USD)'), orange_colorize('ChangePercent24Hr'), orange_colorize('Vwap24Hr'), orange_colorize('Market Cap (USD)')]
        t.rows = data.map do |d|
          [
            green_colorize((d[:rank] || 0).to_s),
            green_colorize((d[:symbol] || 0).to_s),
            green_colorize(format("%.4f", d[:priceUsd].to_f)),
            yellow_colorize(format("%.2f", d[:changePercent24Hr].to_f)),
            yellow_colorize(format("%.2f", d[:vwap24Hr].to_f)),
            green_colorize(format("%.4f", d[:marketCapUsd].to_f))
          ]
        end
      end
      table
    end

    def method_missing(method, arg)
      return super unless method.to_s.end_with?('_colorize')
      color = method.to_s.gsub('_colorize', '').to_sym
      send :colorize, arg, color
    end

    def usdt_result
      query_for_hash unless @result_hash
      return [] unless @result_hash[:data]
      lines = []
      data = @result_hash[:data][0]
      symbol = data[:symbol] || data[:currency_pair]
      price = data[:last]
      lines << symbol.to_s.color(:red)
      lines << price.to_s.color(:green)
      lines << ""
    end

    def result
      output = []
      output << usdt_result
      output.flatten
    end

    def make_http_request(url)
      response = Net::HTTP.get_response(URI(url))
      JSON.parse(response.body, symbolize_names: true)
    end

    def colorize(str, color)
      str.color(color) rescue ''
    end
  end
end
