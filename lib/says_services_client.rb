require "typhoeus"
require "says_services_client/config"
require 'active_model'
require 'active_support/all'
require 'hashie'

require 'says_services_client/utils/class_level_inheritable_attributes'
require 'says_services_client/utils/connection'
require 'says_services_client/utils/operation_concerns'

require 'says_services_client/models/base'
require 'says_services_client/models/campaign'
require 'says_services_client/models/campaign_list'
require 'says_services_client/models/share'
require 'says_services_client/models/share_list'
require 'says_services_client/models/share_stat'
require 'says_services_client/models/trigger'
require 'says_services_client/models/user'
require 'says_services_client/models/cashout'
require 'says_services_client/models/last_job'

module SaysServicesClient
  class MissingEndpoint < StandardError
  end  
end
