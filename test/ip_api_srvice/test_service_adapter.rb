# frozen_string_literal: true

require 'test_helper'
require 'ip_api_service'
require 'ip_api_service/service_adapter'
require 'webmock/minitest'

class IpApiAdapterTest < Minitest::Test
  def test_request_path
    ip = '8.8.8.8'
    result_format = (IpApiService.available_formats - [:ip_meta_info]).sample
    fields = IpApiService.available_fields.sample(3).sort
    lang = IpApiService.available_languages.sample
    stub_request(:get, /ip-api.com.*/).to_return(status: 200)
    IpApiService::ServiceAdapter.new.ip_info ip, fields, result_format, lang
    requestable_fields = (%i[status message query] + fields).join ','
    url = "ip-api.com/#{result_format}/#{ip}?fields=#{requestable_fields}&lang=#{lang}"
    assert_requested :get, url
  end
end
