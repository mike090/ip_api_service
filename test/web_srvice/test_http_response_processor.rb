# frozen_string_literal: true

require 'test_helper'
require 'web_service/http_response_processor'
require 'net/http'

class HttpResponseProcessorTest < Minitest::Test
  def test_response_processor_raises_http_service_error
    mock = Net::HTTPMovedPermanently.new 1.0, 301, 'Redirected'
    target = WebService::HttpResponseProcessor.new
    assert_raises(WebService::HttpServiceError) { target.process_response mock }
  end
end
