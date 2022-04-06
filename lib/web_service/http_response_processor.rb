# frozen_string_literal: true

require 'net/http'

module WebService
  class HttpServiceError < StandardError
    attr_reader :status_code, :service_message

    def initialize(status_code, service_message)
      @status_code = status_code
      @service_message = service_message
      super 'Service error'
    end
  end

  class HttpResponseProcessor
    def process_response(response)
      raise HttpServiceError.new(response.code, response.message) unless response.is_a? Net::HTTPSuccess

      response
    end
  end
end
