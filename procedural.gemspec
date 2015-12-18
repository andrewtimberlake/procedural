# -*- coding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "procedural/version"

Gem::Specification.new do |gem|
  gem.version     = Procedural::VERSION
  gem.name        = "procedural"
  gem.authors     = ["Andrew Timberlake"]
  gem.email       = ["andrew@andrewtimberlake.com"]
  gem.homepage    = "http://github.com/andrewtimberlake/procedural"
  gem.summary     = %q{A way to manage functions, triggers and stored procedures with ActiveRecord}
  gem.description = %q{A way to manage functions, triggers and stored procedures with ActiveRecord}
  gem.license     = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  ##
  # Dependencies
  #
  gem.required_ruby_version = ">= 2.0.0"
  gem.add_dependency "activerecord", ">= 3.2.0"
  gem.add_dependency "activesupport", ">= 3.2.0"

  ##
  # Development dependencies
  #
  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency 'minitest-spec-expect'
end
