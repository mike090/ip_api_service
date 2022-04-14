# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift File.expand_path('./ip_api_service', __dir__)
$LOAD_PATH.unshift File.expand_path('./web_service', __dir__)

require 'ip_api_service'

require 'minitest/autorun'
require 'minitest-power_assert'
