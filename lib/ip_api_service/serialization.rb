# frozen_string_literal: true

require 'happymapper'
require_relative 'json_parser'

module IpApiService
  module Serialization
    module_function

    class UnknownTypeError < StandardError; end

    @type_map = {
      string: String,
      integer: Integer,
      float: Float,
      time: Time,
      date: Date,
      datetime: DateTime,
      boolean: HappyMapper::Boolean
    }

    def json_parser(fields)
      JsonParser.new fields
    end

    def xml_parser(root, fields)
      parser = Class.new.include HappyMapper
      parser.tag root
      fields.each do |field, field_type|
        begin
          field_type = @type_map.fetch field_type
        rescue KeyError
          raise UnknownTypeError "Unknown field type :#{field_type}"
        end
        parser.element field, field_type
      end
      parser
    end
  end
end
