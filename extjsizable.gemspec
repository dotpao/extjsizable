# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "extjsizable"
  s.version     = "2.0.0"
  s.authors     = ["Ungue", "dotpao"]
  s.email       = ["carlos@rodriguez-ruiz.com"]
  s.summary     = "Adds `to_extjs` to ActiveRecord models and arrays to serialize JSON for Ext JS."
  s.description = "Allows your models and collections to generate the JSON structure expected by Ext JS 4-compatible frontends."
  s.homepage    = "https://github.com/dotpao/extjsizable"
  s.license     = "MIT"

  s.required_ruby_version = ">= 2.6"

  s.files = Dir["lib/**/*", "spec/**/*", "README.rdoc", "LICENSE.txt"]
  s.require_paths = ["lib"]

  # Runtime dependencies
  s.add_runtime_dependency "activerecord", ">= 5.2"
  s.add_runtime_dependency "activesupport", ">= 5.2"

  # Development dependencies
  s.add_development_dependency "rspec", "~> 3.12"
  s.add_development_dependency "bundler", "~> 2.0"
  s.add_development_dependency "rake", "~> 13.0"
end
