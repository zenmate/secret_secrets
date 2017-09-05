# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'secret_secrets/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'secret_secrets'
  s.version     = SecretSecrets::VERSION
  s.authors     = ['Marc Greenstock']
  s.email       = ['marc@marcgreenstock.com']
  s.homepage    = 'https://github.com/marcgreenstock/secret_secrets'
  s.summary     = 'Encrypt an additional secrets file for really important secrets.'
  s.description = 'Encrypt an additional secrets file for really important secrets.'
  s.license     = 'MIT'

  s.files         = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files    = Dir['spec/**/*']
  s.require_paths = ['lib']

  s.add_dependency 'rails', '~> 4.2'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-console'
end
