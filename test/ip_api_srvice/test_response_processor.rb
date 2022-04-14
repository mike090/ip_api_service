# frozen_string_literal: true

require 'test_helper'
require 'ip_api_service/response_processor'
require 'net/http/responses'
require 'webmock/minitest'

class IpApiResponseProcessorTest < Minitest::Test
  def test_process_xml_response
    processor = IpApiService::ResponseProcessor.new
    url = 'ip-api.com'
    fields = %i[country countryCode region regionName city zip lat lon timezone isp org as]
    xml_response = File.read('./test/fixtures/response.xml')
    stub_request(:get, url).to_return(status: 200, body: xml_response)
    response = Net::HTTP.get_response(url, '/')
    target = processor.process_response response, :xml, fields
    assert { fields & target.public_methods == fields }
  end

  def test_process_json_response
    processor = IpApiService::ResponseProcessor.new
    url = 'ip-api.com'
    fields = %i[country countryCode region regionName city zip lat lon timezone isp org as]
    json_response = File.read('./test/fixtures/response.json')
    stub_request(:get, url).to_return(status: 200, body: json_response)
    response = Net::HTTP.get_response(url, '/')
    target = processor.process_response response, :json, fields
    assert { fields & target.public_methods == fields }
  end
end
