require "typhoeus"
require "says_services_client/config"
require 'active_model'
require 'active_support/all'

utils = File.join(File.dirname(__FILE__), "says_services_client", "utils", "*.rb")
Dir.glob(utils).each {|file| require file}
models = File.join(File.dirname(__FILE__), "says_services_client", "models", "*.rb")
Dir.glob(models).each {|file| require file}

module SaysServicesClient
  class MissingEndpoint < StandardError
  end
  
  class Campaign < Models::Campaign; end
  class Share < Models::Share; end
  class CampaignList < Models::CampaignList; end
end
