# frozen_string_literal: true

require_relative './ip_api_service/ip_api_adapter'
require 'resolv'

module IpApiService
  extend self

  AVAILABLE_LANGUAGES = %i[en de es pt-BR fr ja zh-CN ru].freeze

  AVAILABLE_FORMATS = %i[ipMetaInfo json xml csv line php].freeze

  DEFAULT_FIELDS = %i[country countryCode region regionName city zip lat lon timezone isp org as].freeze
  private_constant :AVAILABLE_LANGUAGES, :AVAILABLE_FORMATS, :DEFAULT_FIELDS

  @default_language = :en
  @custom_default_fields = DEFAULT_FIELDS
  @result_format = :ipMetaInfo

  attr_reader :available_langviges, :available_formats, :default_language, :result_format

  def available_fields
    META_FIELDS.keys
  end

  def available_languages
    AVAILABLE_LANGUAGES
  end

  def default_language=(value)
    @default_language = AVAILABLE_LANGUAGES.include?(value) ? value : :en
  end

  def result_format=(value)
    @result_format = AVAILABLE_FORMATS.include?(value) ? value : metaInfo
  end

  def field_description(field)
    META_FIELDS[field][:description]
  end

  def default_fields=(value)
    value &= META_FIELDS.keys
    @custom_default_fields = value.empty? ? @default_fields : value
  end

  def default_fields
    @custom_default_fields
  end

  def lookup(ip, fields: default_fields, result_format: @result_format, lang: @default_language)
    raise ArgumentError, 'Unavailable result_format' unless AVAILABLE_FORMATS.include? result_format
    raise ArgumentError, 'Unavailable language' unless AVAILABLE_LANGUAGES.include? lang

    resolv = ip =~ Resolv::IPv4::Regex ? true : (ip =~ Resolv::IPv6::Regex)
    raise ArgumentError, 'Invalid ip addess' unless resolv

    fields = default_fields if fields.empty?
    adapter.ip_meta_info ip, fields, result_format, lang
  end

  private

  def adapter
    @adapter ||= IpApiAdapter.new
  end
end
