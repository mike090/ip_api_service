# frozen_string_literal: true

require 'happymapper'

module IpApiService
  module Serialization
    module_function

    class UnknownTypeError < StandardError; end

    # подскажи, как обозвать
    @type_tra_ta_ta = {
      string: String,
      integer: Integer,
      float: Float,
      time: Time,
      date: Date,
      datetime: DateTime,
      boolean: HappyMapper::Boolean
    }

    class JsonParser
      def initialize(fields)
        fields = fields.keys if fields.is_a? Hash
        @fields = fields
      end

      def parse(json_content)
        raw = JSON.parse(json_content).transform_keys(&:to_sym).slice(*@fields)
        Struct.new(*raw.keys).new(*raw.values_at(*raw.keys))
      end
    end

    def json_parser(fields)
      JsonParser.new fields
    end

    def xml_parser(root, fields)
      parser = Class.new.include HappyMapper
      parser.tag root
      fields.each do |field, field_type|
        begin
          field_type = @type_tra_ta_ta.fetch field_type
        rescue KeyError
          raise UnknownTypeError "Unknown field type :#{field_type}"
        end
        parser.element field, field_type
      end
      parser
    end
  end
end
