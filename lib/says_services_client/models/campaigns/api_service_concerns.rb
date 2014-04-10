module SaysServicesClient
  module Models
    module Campaigns
      module ApiServiceConcerns
        extend ActiveSupport::Concern
  
        module ClassMethods
          def find(campaign_id, options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten          
            raise ActiveModel::MissingAttributeError.new("user_id") if includes.include?(:share_by_user_id) && !options.has_key?(:user_id)
          
            conn = establish_connection("/api/v2/campaigns/#{campaign_id}", params: options)
          
            if block_given?
              conn.on_complete do |response|
                campaign = instantiate(JSON.parse(response.body))
                if includes.include?(:share_by_user_id) && !options[:user_id].blank?
                  shares = request_share_by_user_id(options[:user_id], campaign.id)
                  campaign.instance_variable_set("@shares", shares)
                end
                yield campaign
              end
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              campaign = instantiate(JSON.parse(response.body))
              if includes.include?(:share_by_user_id) && !options[:user_id].blank?
                shares = request_share_by_user_id(options[:user_id], campaign.id)
                campaign.instance_variable_set("@shares", shares)
              end
              campaign
            end
          end      
        
          def all(options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten
            raise ActiveModel::MissingAttributeError.new("user_id") if includes.include?(:share_by_user_id) && !options.has_key?(:user_id)
          
            conn = establish_connection("/api/v2/campaigns", params: options)
          
            if block_given?
              conn.on_complete do |response|
                campaigns = JSON.parse(response.body)["campaigns"].collect {|campaign| instantiate(campaign)}
                if includes.include?(:share_by_user_id) && !options[:user_id].blank?
                  shares = request_share_by_user_id(options[:user_id], campaigns.map(&:id))
                  campaigns_shares_mapping(campaigns, shares)
                end
                yield campaigns
              end          
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              campaigns = JSON.parse(response.body)["campaigns"].collect {|campaign| instantiate(campaign)}
              if includes.include?(:share_by_user_id) && !options[:user_id].blank?
                shares = request_share_by_user_id(options[:user_id], campaigns.map(&:id))
                campaigns_shares_mapping(campaigns, shares)
              end
              campaigns
            end
          end
        end
      end
    end
  end
end
