# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'normalizexml/version'

Gem::Specification.new do |spec|
  spec.name          = "normalizexml"
  spec.version       = NormalizeXml::VERSION
  spec.authors       = ["Jeff McAffee"]
  spec.email         = ["jeff@ktechsystems.com"]
  spec.description   = %q{NormalizeXml is a utility to normalize XML files for easy comparison.}
  spec.summary       = %q{Normalize XML files for easy comparison}
  spec.homepage      = ""
  spec.license       = "Mine"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-mocks"
  #spec.add_runtime_dependency "win32ole"
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "ktcommon"
  spec.add_runtime_dependency "user-choices"
end
