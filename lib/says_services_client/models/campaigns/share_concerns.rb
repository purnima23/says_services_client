module SaysServicesClient
  module Models
    module Campaigns
      module ShareConcerns
        extend ActiveSupport::Concern
        
        module ClassMethods
          def include_request_share_by_user_id(user_id, campaigns)
            shares = request_share_by_user_id(user_id, campaigns.map(&:id))
            campaigns_shares_mapping(campaigns, shares)
          end
          
          private
          def campaigns_shares_mapping(campaigns, shares)
            campaigns.each do |campaign|
              campaign.instance_variable_set("@shares", shares.select {|s| s.campaign_id == campaign.id})
            end
          end
        
          def request_share_by_user_id(user_id, campaign_ids)
            campaign_ids = (campaign_ids.is_a?(Array) ? campaign_ids : [campaign_ids])
            SaysServicesClient::Share.find_by_user_id(user_id, campaign_ids: campaign_ids)
          end
        end
  
        def share_by_user_id(user_id)
          (instance_variable_get("@shares") || []).find {|share| share.user_id == user_id}
        end
      end
    end
  end
end
