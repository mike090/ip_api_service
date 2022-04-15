# frozen_string_literal: true

require 'test_helper'
require 'net/http'
require 'web_service/http_command'
require 'webmock/minitest'

class HttpCommandTest < Minitest::Test
  def test_execute_return_http_response
    url = 'http://some-service.net'
    stub_request(:get, url)
      .to_return(status: 200)
    command = WebService::HttpCommand.new
    result = command.execute :get, url
    assert_kind_of(Net::HTTPOK, result)
  end

  def test_map_template
    host = 'some-service.net'
    template = "http://#{host}/{param1}{?param2}{&param3}"
    stub_request(:get, Regexp.new("#{host}.*"))
      .to_return(status: 200)
    command = WebService::HttpCommand.new
    command.execute :get, template, param1: :value1, param2: %i[item1 item2], param3: :value3,
                                    param4: :value4
    assert_requested(:get, "http://#{host}/value1?param2=item1,item2&param3=value3")
  end

  def test_send_headers
    url = 'http://some-service.net'
    headers = {
      'User-Agent' => 'IpApiService/Ruby/1.0',
      'Accept' => 'application/json',
      'Accept-Encoding' => 'utf-8'
    }
    body = 'some qyery'
    stub_request(:post, url)
      .to_return(status: 200, body: body)
    target = WebService::HttpCommand.new
    target.execute :post, url, headers: headers, body: body
    assert_requested :post, url, headers: headers, body: body
  end

  def test_raises_unknown_method_error
    url = 'http://some-service.net'
    target = WebService::HttpCommand.new
    assert_raises(WebService::HttpUnknownMethodError) { target.execute :grab, url }
  end
end
