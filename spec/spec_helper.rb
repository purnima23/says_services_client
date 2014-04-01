require 'bundler/setup'
Bundler.setup

require 'typhoeus' # and any other gems you need
require 'rspec'
require 'says_services_client'
require 'vcr'

ENV["RAILS_ENV"] = 'test'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # some (optional) config here
end

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path("../vcr", __FILE__)
  c.hook_into :typhoeus
  c.allow_http_connections_when_no_cassette = true
end