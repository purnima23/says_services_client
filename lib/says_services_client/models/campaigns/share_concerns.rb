module SaysServicesClient
  module Models
    module Campaigns
      module ShareConcerns
        extend ActiveSupport::Concern
        
        def share_by_user_id(user_id)
          shares.find {|share| share.user_id == user_id}
        end
        
        private        
        module ClassMethods
          def include_request_share_by_user_id(country, user_id, campaigns)
            shares = request_share_by_user_id(country, user_id, campaigns.map(&:id))["shares"]
            campaigns_shares_mapping(campaigns, shares)
          end
          
          private
          def campaigns_shares_mapping(campaigns, shares)
            campaigns.each do |campaign|
              campaign.shares = shares.select {|s| s.campaign_id == campaign.id}
            end
          end
        
          def request_share_by_user_id(country, user_id, campaign_ids)
            SaysServicesClient::Share.find_by_user_id(user_id, campaign_ids: campaign_ids, country: country)
          end
          
          def include_share_by_user_id(campaigns, args={})
            return if campaigns.blank?
            include_request_share_by_user_id(args[:country], args[:user_id], campaigns)
          end
        end
      end
    end
  end
end
