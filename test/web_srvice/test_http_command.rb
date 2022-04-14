# frozen_string_literal: true

require 'test_helper'
require 'web_service/http_command'
require 'webmock/minitest'

class UriMapperTest < Minitest::Test
  def test_http_command_method
    url = 'http://ip-api.com'
    stub_request(:get, url)
      .to_return(status: 200, body: 'test_response')
    target = WebService::HttpCommand.new WebService::UriMapper
    target.execute :get, url
    assert_requested :get, url
  end

  def test_http_command_headers
    url = 'http://www.example.com/action/execute'
    headers = {
      'User-Agent' => 'IpApiService/Ruby/1.0',
      'Accept' => 'application/json'
    }
    body = 'body'
    stub_request(:post, url)
      .with(headers: headers, body: body)
      .to_return(status: 201, body: 'success')
    target = WebService::HttpCommand.new WebService::UriMapper
    target.execute :post, url, headers: headers, body: body
    assert_requested :post, url
  end

  def test_http_command_raises_connection_error
    WebMock.enable_net_connect!
    url = 'http://abra-cadabra.xxx'
    target = WebService::HttpCommand.new WebService::UriMapper
    assert_raises(WebService::ConnectionError) { target.execute :get, url }
    WebMock.disable_net_connect!
  end

  def test_http_command_raises_unknown_method_error
    url = 'http://abra-cadabra.xxx'
    target = WebService::HttpCommand.new WebService::UriMapper
    assert_raises(WebService::HttpUnknownMethodError) { target.execute :grab, url }
  end
end
