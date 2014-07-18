require "typhoeus"
require "says_services_client/config"
require 'active_model'
require 'active_support/all'
require 'active_record/errors'
require 'active_record/validations'
require 'active_record/reflection'
require 'hashie'
require 'will_paginate/collection'

require 'says_services_client/utils/connection'
require 'says_services_client/models/base'
require 'says_services_client/models/share'
require 'says_services_client/models/campaign'
require 'says_services_client/models/share_stat'
require 'says_services_client/models/user'
require 'says_services_client/models/cashout'
require 'says_services_client/models/last_job'
require 'says_services_client/models/traffic_referrer'
require 'says_services_client/models/transaction'
require 'says_services_client/models/history'
require 'says_services_client/models/trigger'

module SaysServicesClient
  class MissingEndpoint < StandardError
  end  
  
  Campaign.class_eval {coerce_key :triggers, SaysServicesClient::Trigger}
end
