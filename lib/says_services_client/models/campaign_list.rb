require 'says_services_client/models/campaign_lists/api_service_concerns'

module SaysServicesClient
  class CampaignList < Models::Base
    include SaysServicesClient::Models::CampaignLists::ApiServiceConcerns
    
    attr_reader :offset, :campaigns
  end
end