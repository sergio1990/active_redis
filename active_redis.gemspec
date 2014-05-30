# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_redis/version'

Gem::Specification.new do |spec|
  spec.name          = "active_redis"
  spec.version       = ActiveRedis::VERSION
  spec.authors       = ["Sergey Gernyak"]
  spec.email         = ["sergeg1990@gmail.com"]
  spec.description   = %q{Small childly ORM for Redis}
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redis",         '3.0.7'
  spec.add_dependency "activesupport", '>= 3.0.0'
  spec.add_dependency "colorize",      '0.7.3'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rake-notes"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "turn"
end
