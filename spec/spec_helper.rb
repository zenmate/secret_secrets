# frozen_string_literal: true

require 'simplecov'
require 'simplecov-console'

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::Console,
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
else
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [SimpleCov::Formatter::Console,
     SimpleCov::Formatter::HTMLFormatter]
  )
end

SimpleCov.start do
  coverage_dir 'coverage'
end

ENV['RAILS_ENV'] = 'test'

require "#{File.dirname(__FILE__)}/dummy/config/environment.rb"
require 'rspec/rails'

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = true
  config.order = 'random'
end
