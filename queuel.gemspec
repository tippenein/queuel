# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'queuel/version'

Gem::Specification.new do |spec|
  spec.name          = "queuel"
  spec.version       = Queuel::VERSION
  spec.authors       = ["Jon Phenow"]
  spec.email         = ["j.phenow@gmail.com"]
  spec.description   = %q{Light Queue wrapper tool}
  spec.summary       = %q{Light Queue wrapper tool}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "iron_mq"
  spec.add_development_dependency "json", "~> 1.7.7"
end
