# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'citibike/version'

Gem::Specification.new do |spec|
  spec.name          = "citibike"
  spec.version       = Citibike::VERSION
  spec.authors       = ["Ethan Langevin"]
  spec.email         = ["ejl6266@gmail.com"]
  spec.description   = %q{Client for the unofficial Citibike API in NYC}
  spec.summary       = %q{Provides an interface for interacting with Citibike NYC data}
  spec.homepage      = "http://github.com/ejlangev/citibike"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "mocha"

  spec.add_development_dependency "debugger"

  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "faraday_middleware"
  spec.add_runtime_dependency "yajl-ruby"
end
