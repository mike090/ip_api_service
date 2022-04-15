# frozen_string_literal: true

require 'test_helper'
require 'webmock'

class TestIpApiService < Minitest::Test
  def test_lookup
    stub_request(:get, /ip-api.com.*/).to_return(status: 200, body: File.read('./test/fixtures/response.xml'))
    fields = IpApiService.available_fields.sample(5)
    target = IpApiService.lookup '8.8.8.8', fields: fields
    assert { fields == fields & target.public_methods(false) }
  end

  def test_lookup_raw
    stub_request(:get, /ip-api.com.*/).to_return(status: 200, body: File.read('./test/fixtures/response.xml'))
    fields = IpApiService.available_fields.sample(5)
    target = IpApiService.lookup '8.8.8.8', fields: fields, result_format: :line
    assert_instance_of String, target
  end
end
