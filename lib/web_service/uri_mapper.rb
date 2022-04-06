# frozen_string_literal: true

require 'addressable/template'

module WebService
  module UriMapper
    module_function

    def map_template(template, **mapping)
      Addressable::Template.new(template).expand mapping
    end
  end
end
