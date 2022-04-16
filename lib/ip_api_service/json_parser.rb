# frozen_string_literal: true

module IpApiService
  module Serialization
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
  end
end
