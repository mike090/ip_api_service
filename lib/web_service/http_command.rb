# frozen_string_literal: true

require 'net/http'

module WebService
  class HttpUnknownMethodError < StandardError; end
  class ConnectionError < StandardError; end

  HTTP_COMMAND_METHODS = {
    get: Net::HTTP::Get,
    post: Net::HTTP::Post,
    head: Net::HTTP::Head,
    patch: Net::HTTP::Patch,
    put: Net::HTTP::Put,
    proppatch: Net::HTTP::Proppatch,
    lock: Net::HTTP::Lock,
    unlock: Net::HTTP::Unlock,
    options: Net::HTTP::Options,
    propfind: Net::HTTP::Propfind,
    delete: Net::HTTP::Delete,
    move: Net::HTTP::Move,
    copy: Net::HTTP::Copy,
    mkol: Net::HTTP::Mkcol,
    trace: Net::HTTP::Trace
  }.freeze
  private_constant :HTTP_COMMAND_METHODS

  class HttpCommand
    def initialize(mapper)
      @mapper = mapper
    end

    def execute(command, template, **params) # rubocop:disable Metrics/AbcSize
      request_class = HTTP_COMMAND_METHODS[command]
      raise HttpUnknownMethodError, "Unknown Http command: #{command}" unless request_class

      headers = (params.delete :headers) || {}
      body = params.delete :body
      body = nil unless request_class::REQUEST_HAS_BODY
      uri = @mapper.map_template template, **params
      request = request_class.new uri, {}
      headers.each { |header, value| request[header] = value }
      begin
        Net::HTTP.start(uri.host, uri.port) { |http| http.request request, body }
      rescue StandardError
        raise ConnectionError, 'Service unavailable'
      end
    end
  end
end
