# frozen_string_literal: true

require 'test_helper'
require 'webmock'

class TestIpApiService < Minitest::Test
  def test_lookup
    WebMock.allow_net_connect!
    fields = IpApiService.available_fields
    fields = fields.sample 5
    target = IpApiService.lookup '8.8.8.8', fields: fields
    assert { fields == fields & target.public_methods(false) }
    WebMock.disable_net_connect!
  end

  def test_lookup_raw
    WebMock.allow_net_connect!
    fields = IpApiService.available_fields
    fields = fields.sample 5
    target = IpApiService.lookup '8.8.8.8', fields: fields, result_format: :line
    assert_instance_of String, target
    WebMock.disable_net_connect!
  end

  def test_lookup_privare_range_ip
    WebMock.allow_net_connect!
    assert_raises(IpApiService::ServiceError) { IpApiService.lookup '192.168.0.1' }
    WebMock.disable_net_connect!
  end
end
