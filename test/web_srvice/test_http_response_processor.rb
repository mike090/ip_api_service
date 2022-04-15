# frozen_string_literal: true

require 'test_helper'
require 'web_service/http_response_processor'
require 'net/http'

class HttpResponseProcessorTest < Minitest::Test
  def test_raises_http_service_error_unless_httpok
    stub_request(:any, /.*/).to_return(status: 301)
    response = WebService::HttpCommand.new.execute :get, 'http://some-service.net'
    assert_raises(WebService::HttpServiceError) { WebService::HttpResponseProcessor.new.process_response response }
  end
end
