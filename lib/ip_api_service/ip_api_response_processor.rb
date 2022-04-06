# frozen_string_literal: true

require_relative '../web_service/http_response_processor'
require_relative 'serialization'

module IpApiService
  XML_RESPONSE_ROOT = 'query'
  private_constant :XML_RESPONSE_ROOT

  IP_API_SUCCESS_STATUS = 'success'
  private_constant :IP_API_SUCCESS_STATUS

  class ResponseProcessorError < StandardError; end

  class ServiceError < StandardError
    attr_reader :query, :service_message

    def initialize(query, service_message)
      @query = query
      @service_message = service_message
      super 'Service return fail result'
    end
  end

  class ResponseProcessor < WebService::HttpResponseProcessor
    def process_response(response, content_type, fields)
      super response
      ip_api_result = service_parser(content_type).parse response.body
      unless ip_api_result.status == IP_API_SUCCESS_STATUS
        raise ServiceError.new(ip_api_result.query,
                               ip_api_result.message)
      end

      parser(content_type, fields).parse response.body
    end

    private

    def parser(content_type, fields)
      case content_type
      when :xml
        fields = FIELD_TYPES.slice(*fields) unless fields.is_a? Hash
        Serialization.xml_parser XML_RESPONSE_ROOT, fields
      when :json
        Serialization.json_parser fields
      else
        raise ResponseProcessorError 'Parser not implemented'
      end
    end

    def service_parser(content_type)
      case content_type
      when :xml
        @xml_service_parser || parser(:xml, SERVICE_FIELDS)
      when :json
        @json_service_parser || parser(:json, SERVICE_FIELDS)
      end
    end
  end
end
