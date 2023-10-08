require "uri"
require "net/http"
require "json"
require "rainbow/ext/string"
require "terminal-table"

module Blade
  class Coin
    def initialize(input)
      @coin = input
      query_for_hash
    end

    def query_for_hash
      query_url = get_mxc_single_market(@coin)
      @result_hash = make_http_request(query_url)
    end

    def get_mxc_single_market(coin)
      "https://www.mexc.com/open/api/v2/market/ticker?symbol=#{coin}_USDT"
    end

    def get_top_markets(top = 10)
      query_url = "https://api.coincap.io/v2/assets?limit=#{top}"
      result_json = make_http_request(query_url)
      data = result_json[:data]

      timestamp = result_json[:timestamp] / 1000 rescue ''
      formatted_time = Time.at(timestamp).strftime("%I:%M:%S %p")
      puts green_colorize("Data source from coincap.io at #{formatted_time}")

      display_market_data(data)
    end
    
    def display_market_data(data)
      title = '💰Wishing you prosperity and wealth(恭喜发财)💰'.color(226)
      table = Terminal::Table.new(title: "\e[33m#{title}\e[0m") do |t|
        t.headings = [orange_colorize('Rank'), orange_colorize('Coin'), orange_colorize('Price (USD)'), orange_colorize('ChangePercent24Hr'), orange_colorize('Vwap24Hr'), orange_colorize('Market Cap (USD)')]
        t.rows = data.map do |d|
          [
            green_colorize(d[:rank] || 0),
            green_colorize(d[:symbol] || 0),
            green_colorize(format("%.4f", d[:priceUsd].to_f)),
            yellow_colorize(format("%.2f", d[:changePercent24Hr].to_f)),
            yellow_colorize(format("%.2f", d[:vwap24Hr].to_f)),
            green_colorize(format("%.4f", d[:marketCapUsd].to_f))
          ]
        end
      end
      table
    end

    def green_colorize(str)
      colorize(str, :green)
    end

    def orange_colorize(str)
      colorize(str, :orange)
    end

    def yellow_colorize(str)
      colorize(str, :yellow)
    end

    def usdt_result
      return [] unless @result_hash[:data]
      lines = []
      data = @result_hash[:data][0]
      lines << data[:symbol].color(:red)
      lines << data[:last].color(:green)
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
