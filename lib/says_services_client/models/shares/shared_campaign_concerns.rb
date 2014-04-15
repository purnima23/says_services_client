module SaysServicesClient
  module Models
    module Shares
      module SharedCampaignConcerns
        extend ActiveSupport::Concern
        
        module ClassMethods
          def include_shared_campaign(shares, campaign_ids)
            shared_campaigns = SaysServicesClient::Campaign.all(ids: campaign_ids)
            shares_campaigns_mapping(shares, shared_campaigns)
          end
          
          private
          def shares_campaigns_mapping(shares, shared_campaigns)
            shares.each do |share|
              share.instance_variable_set("@campaign", shared_campaigns.select {|c| c.id == share.campaign_id})
            end
          end
        end
  
        def campaign
          instance_variable_get("@campaign")
        end
      end
    end
  end
end
