# encoding: UTF-8

require 'faraday'
require 'faraday_middleware'
require 'yajl'

module Citibike
  # Class representing a Faraday instance used to connect to the
  # actual Citibike API, takes a variety of options
  class Connection

    def initialize(opts = {})
      @options = {
        adapter: Faraday.default_adapter,
        headers: {
          'Accept' => 'application/json; charset=utf-8',
          'UserAgent' => 'Citibike Gem'
        },
        proxy: nil,
        ssl: {
          verify: false
        },
        debug: false,
        test: false,
        stubs: nil,
        raw: false,
        format_path: true,
        format: :json,
        url: 'http://appservices.citibikenyc.com/'
      }
      # Reject any keys that aren't already in @options
      @options.keys.each do |k|
        @options[k] = opts[k] if opts.key?(k)
      end
    end

    def http
      @http ||= Faraday.new(@options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use Faraday::Response::ParseJson unless @options[:raw]
        connection.use Faraday::Response::Logger if @options[:debug]
        if @options[:test]
          connection.adapter(@options[:adapter], @options[:stubs])
        else
          connection.adapter(@options[:adapter])
        end
      end
    end

    #
    # Makes a request to the API through the set up interface
    # @param  method [Symbol] [:get, :post, :put, :delete]
    # @param  path [String] [The path to request from the server]
    # @param  options = {} [Optional Hash] [Args to include in the request]
    #
    # @return [String or Hash] [The result of the request, generally a hash]
    def request(method, path, options = {})
      if @options[:format_path]
        path = format_path(path, @options[:format])
      end
      response = self.http.send(method) do |request|
        case method
        when :get, :delete
          request.url(path, options)
        when :post, :put
          request.path = path
          request.body = options unless options.empty?
        end
      end
      response.body
    end

    private

      def format_path(path, format)
        if path =~ /\./
          path
        else
          [path, format].map(&:to_s).compact.join('.')
        end
      end

  end

end