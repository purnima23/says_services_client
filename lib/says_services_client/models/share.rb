require 'says_services_client/models/shares/api_service_concerns'

module SaysServicesClient
  module Models
    class Share < Base
      include SaysServicesClient::Models::Shares::ApiServiceConcerns
      
      attr_accessor :id, :uniq_total_clicked_count, :total_clicked_count, :message, :reward_count, :rewarded_uv_count, :user_id, :campaign_id, :created_at, :username
      attr_reader :share_url
      attr_protected :uniq_total_clicked_count, :total_clicked_count, :reward_count, :rewarded_uv_count      
      
      validates_presence_of :username, on: :create
    end
  end
end