require 'bundler/setup'
Bundler.setup

require 'typhoeus' # and any other gems you need
require 'rspec'
require 'says_services_client'
require 'shoulda-matchers'
require 'vcr'

ENV["RAILS_ENV"] = 'test'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # some (optional) config here
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path("../vcr", __FILE__)
  c.hook_into :typhoeus
  c.configure_rspec_metadata!
end

def reset_class class_name
  Object.send(:remove_const, class_name) rescue nil
  klass = Object.const_set(class_name, Class.new(SaysServicesClient::Models::Base))

  klass.class_eval do
    attr_accessor :name, :email, :id
    attr_reader :address
    
    validates_presence_of :name
    validates_presence_of :email, on: :create
    validates_presence_of :address, on: :update
  end
  klass
end