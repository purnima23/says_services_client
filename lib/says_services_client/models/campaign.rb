module SaysServicesClient
  module Models
    class Campaign < Base
      ATTRIBUTES = [:id, :user_id, :title, :site_url, :end_date, :photo, :campaign_about, :state, :featured, :supporters_count, :identifier, :start_date, :total_reward, :reward_amount, :reward_type, :reward_count, :bit_columns, :exceptional_url, :click_limit, :site_screenshot, :reference_cap_limit, :admin_category, :acquisitioin_reward_amount, :acquisition_reward_count, :preview_key, :acquisition_type, :completed_at, :total_unique_visits, :target_uv, :video_id, :country_id, :views_count, :client_domain_id, :type, :paused_at, :created_at, :updated_at]
            
      attr_accessor *ATTRIBUTES
      attr_protected :id
      
      class << self
        def find(campaign_id, options={})
          conn = establish_connection("/api/v2/campaigns/#{campaign_id}", params: options)
          
          if block_given?
            conn.on_complete do |response|
              data = new(JSON.parse(response.body))
              yield data
            end
            SaysServicesClient::Config.hydra.queue(conn)
          else
            response = conn.run
            new(JSON.parse(response.body))
          end
        end      
        
        def all(options={})
          conn = establish_connection("/api/v2/campaigns", params: options)
          
          if block_given?
            conn.on_complete do |response|
              data = JSON.parse(response.body).collect {|campaign| new(campaign)}
              yield data
            end          
            SaysServicesClient::Config.hydra.queue(conn)
          else
            response = conn.run
            JSON.parse(response.body).collect {|campaign| new(campaign)}
          end
        end
      end
    end
  end
end