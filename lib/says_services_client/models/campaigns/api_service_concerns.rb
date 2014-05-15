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
                campaign = parse_campaign(response.body, options: options, includes: includes)
                yield campaign
              end
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              parse_campaign(response.body, options: options, includes: includes)
            end
          end
        
          def all(options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten
            raise ActiveModel::MissingAttributeError.new("user_id") if includes.include?(:share_by_user_id) && !options.has_key?(:user_id)
            
            conn = establish_connection(all_path(options), params: options)
            
            if block_given?
              conn.on_complete do |response|
                campaigns = parse_all_campaigns(response.body, options: options, includes: includes)
                yield campaigns
              end          
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              parse_all_campaigns(response.body, options: options, includes: includes)
            end
          end
          
          def parse_all_campaigns(json, args={})
            args[:includes] ||= []
            args[:options] ||= {}
            campaigns = JSON.parse(json)["campaigns"].collect {|campaign| instantiate(campaign)}
            include_request_share_by_user_id(args[:options][:user_id], campaigns) if args[:includes].include?(:share_by_user_id) && !args[:options][:user_id].blank? && !campaigns.map(&:id).blank?
            campaigns
          end
          
          def parse_campaign(json, args={})
            args[:includes] ||= []
            args[:options] ||= {}
            campaign = instantiate(JSON.parse(json))
            include_request_share_by_user_id(args[:options][:user_id], [campaign]) if args[:includes].include?(:share_by_user_id) && !args[:options][:user_id].blank?
            campaign
          end
          
          private
          def all_path(options)
            ids = [options.delete(:ids)].flatten.compact
            path = "/api/v2/campaigns"
            path += "?ids=#{ids.join(",")}" unless ids.empty?
            path
          end
        end
      end
    end
  end
end
