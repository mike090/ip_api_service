# frozen_string_literal: true

require 'test_helper'
require 'ip_api_service/response_processor'
require 'net/http/responses'
require 'webmock/minitest'
require 'ip_api_service/serialization'

class IpApiResponseProcessorTest < Minitest::Test
  def test_process_xml_response
    processor = IpApiService::ResponseProcessor.new
    url = 'ip-api.com'
    fields = IpApiService.available_fields.sample(5)
    xml = File.read('./test/fixtures/response.xml')
    json = File.read('./test/fixtures/response.json')
    stub_request(:get, url).to_return(status: 200, body: xml)
    response = Net::HTTP.get_response(url, '/')
    target = processor.process_response response, :xml, fields
    assert { fields & target.public_methods == fields }
    etalon = IpApiService::Serialization.json_parser(fields).parse(json)
    fields.each do |field|
      assert_equal target.public_send(field), etalon.public_send(field)
    end
  end

  def test_raises
    processor = IpApiService::ResponseProcessor.new
    host = 'ip-api.com'
    fields = IpApiService.available_fields
    xml = File.read('./test/fixtures/error.xml')
    stub_request(:get, /.*/).to_return(status: 200, body: xml)
    response = Net::HTTP.get_response(host, '/')
    assert_raises(IpApiService::ServiceError) { processor.process_response(response, :xml, fields) }
  end
end
