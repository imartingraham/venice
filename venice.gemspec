# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: venice 0.4.6 ruby lib

Gem::Specification.new do |s|
  s.name = "venice".freeze
  s.version = "0.4.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jeremy Fox".freeze, "Mattt Thompson".freeze]
  s.date = "2019-04-02"
  s.description = "".freeze
  s.email = "contct@jeremyfox.me".freeze
  s.executables = ["iap".freeze]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/iap",
    "lib/venice.rb",
    "lib/venice/client.rb",
    "lib/venice/in_app_receipt.rb",
    "lib/venice/itc_subscription_notification.rb",
    "lib/venice/itc_verification_response.rb",
    "lib/venice/latest_receipt_info.rb",
    "lib/venice/pending_renewal_info.rb",
    "lib/venice/receipt.rb",
    "lib/venice/verification_error.rb",
    "lib/venice/version.rb",
    "spec/client_spec.rb",
    "spec/in_app_receipt_spec.rb",
    "spec/itc_subscription_notification_spec.rb",
    "spec/itc_verification_response_spec.rb",
    "spec/pending_renewal_info_spec.rb",
    "spec/receipt",
    "spec/receipt_spec.rb",
    "spec/spec_helper.rb",
    "venice.gemspec"
  ]
  s.homepage = "https://github.com/atljeremy/venice".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.8".freeze
  s.summary = "iTunes In-App Purchase Receipt Verification".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<commander>.freeze, ["~> 4.1"])
      s.add_runtime_dependency(%q<terminal-table>.freeze, ["~> 1.4"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>.freeze, ["~> 2.3.0"])
    else
      s.add_dependency(%q<json>.freeze, [">= 0"])
      s.add_dependency(%q<commander>.freeze, ["~> 4.1"])
      s.add_dependency(%q<terminal-table>.freeze, ["~> 1.4"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_dependency(%q<jeweler>.freeze, ["~> 2.3.0"])
    end
  else
    s.add_dependency(%q<json>.freeze, [">= 0"])
    s.add_dependency(%q<commander>.freeze, ["~> 4.1"])
    s.add_dependency(%q<terminal-table>.freeze, ["~> 1.4"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<jeweler>.freeze, ["~> 2.3.0"])
  end
end
