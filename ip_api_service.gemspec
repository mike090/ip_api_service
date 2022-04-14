# frozen_string_literal: true

require_relative "lib/ip_api_service/version"

Gem::Specification.new do |spec|
  spec.name = "ip_api_service"
  spec.version = IpApiService::VERSION
  spec.authors = ["mike09"]
  spec.email = ["mike09@mail.ru"]

  spec.summary = "API for ip-api.com"
  spec.homepage = "https://github.com/mike090/ip_api_service"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mike090/ip_api_service"
  spec.metadata["changelog_uri"] = "https://github.com/mike090/ip_api_service"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_runtime_dependency "addressable"
  spec.add_runtime_dependency "nokogiri-happymapper"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-power_assert"
  spec.add_development_dependency "webmock"

end
