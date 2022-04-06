# frozen_string_literal: true

require 'web_service/uri_mapper'
require 'test_helper'

class UriMapperTest < Minitest::Test
  def test_uri_mapper_map_params
    uri_template = 'http://ip-api.com/{format}/{ip}{?fields}{&lang}'
    mapper = WebService::UriMapper
    mapping = { format: :xml, ip: '8.8.8.8', fields: %i[field1 field2 field3], lang: :ru }
    target = mapper.map_template uri_template, **mapping
    assert_instance_of Addressable::URI, target
    assert { target.to_s == 'http://ip-api.com/xml/8.8.8.8?fields=field1,field2,field3&lang=ru' }
  end

  def test_uri_mapper_skip_keys
    mapper = WebService::UriMapper
    target = mapper.map_template 'http://localhost', format: :xml, ip: '8.8.8.8', fields: %i[field1 field2 field3],
                                                     lang: :ru
    assert { target.to_s == 'http://localhost' }
  end
end
