# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'refile/backgrounder/version'

Gem::Specification.new do |spec|
  spec.name          = 'refile-backgrounder'
  spec.version       = Refile::Backgrounder::VERSION
  spec.authors       = ['Logan Serman']
  spec.email         = ['loganserman@gmail.com']
  spec.summary       = 'Asyncronous cache-to-store uploads with Refile.'
  spec.description   = spec.description
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency 'rails', '>= 4.1.0'
  spec.add_dependency 'refile', '>= 0.5.0'
  spec.add_dependency 'activejob', '>= 4.2.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'

end
