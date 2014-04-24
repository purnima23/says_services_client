require 'says_services_client/models/shares/api_service_concerns'
require 'says_services_client/models/shares/operation_service_concerns'
require 'says_services_client/models/shares/shared_campaign_concerns'

module SaysServicesClient
  class Share < Models::Base
    include SaysServicesClient::Models::Shares::ApiServiceConcerns
    include SaysServicesClient::Models::Shares::OperationServiceConcerns
    include SaysServicesClient::Models::Shares::SharedCampaignConcerns
    
    attr_accessor :id, :uniq_total_clicked_count, :total_clicked_count, :message, :reward_count, :rewarded_uv_count, :user_id, :campaign_id, :created_at, :username
    attr_reader :share_url, :fresh
    attr_protected :uniq_total_clicked_count, :total_clicked_count, :reward_count, :rewarded_uv_count      
    
    validates_presence_of :user_id, on: :create
    validates_presence_of :campaign_id, on: :create
    validates_presence_of :username, on: :create
    validates_presence_of :message, on: :create
    
    def fresh
      @fresh ||= false
    end
  end
end