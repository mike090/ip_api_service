# frozen_string_literal: true

require_relative '../web_service/http_command'
require_relative 'response_processor'

module IpApiService
  # available meta fields
  META_FIELDS = {
    continent: { type: :string, description: 'Continent name' },
    continentCode: { type: :string, description: 'Two-letter continent code' },
    country: { type: :string, description: 'Country name' },
    countryCode: { type: :string, description: 'Two-letter country code ISO 3166-1 alpha-2' },
    region: { type: :string, description: 'Region/state short code (FIPS or ISO)' },
    regionName: { type: :string, description: 'Region/state' },
    city: { type: :string, description: 'City' },
    district: { type: :string, description: 'District (subdivision of city)' },
    zip: { type: :string,  description: 'Zip code' },
    lat: { type: :float,   description: 'Latitude' },
    lon: { type: :float,   description: 'Longitude' },
    timezone: { type: :string, description: 'Timezone (tz)' },
    offset: { type: :integer, description: 'Timezone UTC DST offset in seconds' },
    currency: { type: :string, description: 'National currency' },
    isp: { type: :string,  description: 'ISP name' },
    org: { type: :string,  description: 'Organization name' },
    as: { type: :string,
          description: "AS number and organization, separated by space (RIR). Empty for IP blocks \
          'not being announced in BGP tables." },
    asname: { type: :string,
              description: 'AS name (RIR). Empty for IP blocks not being announced in BGP tables' },
    reverse: { type: :string, description: 'Reverse DNS of the IP (can delay response)' },
    mobile: { type: :boolean, description: 'Mobile (cellular) connection' },
    proxy: { type: :boolean, description: 'Proxy, VPN or Tor exit address' },
    hosting: { type: :boolean, description: 'Hosting, colocated or data center' }
  }.freeze

  AVAILABLE_LANGUAGES = %i[en de es pt-BR fr ja zh-CN ru].freeze

  AVAILABLE_FORMATS = %i[ip_meta_info json xml csv line php].freeze

  DEFAULT_FIELDS = %i[country countryCode region regionName city zip lat lon timezone isp org as].freeze
  private_constant :AVAILABLE_LANGUAGES, :AVAILABLE_FORMATS, :DEFAULT_FIELDS

  # service fields
  SERVICE_FIELDS = {
    status: :string,
    message: :string,
    query: :string
  }.freeze

  FIELD_TYPES = META_FIELDS.transform_values do |field_scheme|
    field_scheme[:type]
  end.merge(SERVICE_FIELDS).freeze

  IP_API_COMMAND_TEMPLATE = 'http://ip-api.com/{format}/{ip}{?fields}{&lang}'

  USER_AGENT = 'IpApiService/Ruby/1.0'

  ACCEPT_MIME_TYPES = {
    json: 'application/json',
    xml: 'application/xml',
    csv: 'text/csv',
    newline: 'text/plain',
    php: 'text/php'
  }.freeze
  private_constant :META_FIELDS, :AVAILABLE_LANGUAGES, :AVAILABLE_FORMATS, :DEFAULT_FIELDS, :SERVICE_FIELDS,
                   :FIELD_TYPES, :IP_API_COMMAND_TEMPLATE, :USER_AGENT, :ACCEPT_MIME_TYPES

  class ServiceAdapter
    def initialize
      @command = WebService::HttpCommand.new
    end

    def ip_info(ip, fields, result_format, lang)
      target_fields = SERVICE_FIELDS.keys + fields
      target_format = result_format == :ip_meta_info ? :xml : result_format
      headers = prepare_headers target_format
      response = @command.execute :get, IP_API_COMMAND_TEMPLATE, ip: ip, format: target_format, fields: target_fields,
                                                                 lang: lang, headers: headers
      return response_processor.process_response(response, target_format, fields) if result_format == :ip_meta_info

      response.body
    end

    private

    def response_processor
      @response_processor ||= ResponseProcessor.new
    end

    def prepare_headers(format)
      {
        'User-Agent' => USER_AGENT,
        'Accept' => ACCEPT_MIME_TYPES[format],
        'Accept-Encoding' => 'utf-8'
      }
    end
  end
end
