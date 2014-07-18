module SaysServicesClient
  module Models
    module Shares
      module SharedCampaignConcerns
        extend ActiveSupport::Concern
        
        module ClassMethods
          private
          def shares_campaigns_mapping(shares, shared_campaigns)
            shares.each do |share|
              share.campaign = shared_campaigns.find {|c| c.id == share.campaign_id}
            end
          end
          
          def include_campaign(shares, args={})
            shared_campaigns = SaysServicesClient::Campaign.all(ids: shares.map(&:campaign_id), country: args[:country])['campaigns']
            shares_campaigns_mapping(shares, shared_campaigns)
          end
        end
      end
    end
  end
end
