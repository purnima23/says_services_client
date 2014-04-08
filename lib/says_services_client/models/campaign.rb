module SaysServicesClient
  module Models
    class Campaign < Base
      attr_reader :friendly_id, :is_ended, :is_completed, :remaining_days, :total_available_reward, :per_uv_reward, :site_url, :thumbnail_url, :site_screenshot_url, :triggers      
      attr_accessor :id, :title, :campaign_about, :supporters_count, :views_count, :completed_at, :created_at, :updated_at
      
      validates_presence_of :title
      
      class << self
        def find(campaign_id, options={})
          includes = [options.symbolize_keys!.delete(:include) || []].flatten          
          raise ActiveModel::MissingAttributeError.new("user_id") if includes.include?(:share_by_user_id) && !options.has_key?(:user_id)
          
          conn = establish_connection("/api/v2/campaigns/#{campaign_id}", params: options)
          
          if block_given?
            conn.on_complete do |response|
              campaign = new(JSON.parse(response.body), as: :admin)
              if includes.include?(:share_by_user_id)
                shares = request_share_by_user_id(options[:user_id], campaign.id)
                campaign.instance_variable_set("@shares", shares)
              end
              yield campaign
            end
            SaysServicesClient::Config.hydra.queue(conn)
          else
            response = conn.run
            campaign = new(JSON.parse(response.body), as: :admin)
            if includes.include?(:share_by_user_id)
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
              campaigns = JSON.parse(response.body).collect {|campaign| new(campaign, as: :admin)}
              if includes.include?(:share_by_user_id)
                shares = request_share_by_user_id(options[:user_id], campaigns.map(&:id))
                campaigns_shares_mapping(campaigns, shares)
              end
              yield campaigns
            end          
            SaysServicesClient::Config.hydra.queue(conn)
          else
            response = conn.run
            campaigns = JSON.parse(response.body).collect {|campaign| new(campaign, as: :admin)}
            if includes.include?(:share_by_user_id)
              shares = request_share_by_user_id(options[:user_id], campaigns.map(&:id))
              campaigns_shares_mapping(campaigns, shares)
            end
            campaigns
          end
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