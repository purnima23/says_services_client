module SaysServicesClient
  module Models
    module Campaigns
      module ApiServiceConcerns
        extend ActiveSupport::Concern
  
        module ClassMethods
          def find(campaign_id, options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten          
            raise ActiveModel::MissingAttributeError.new("user_id") if includes.include?(:share_by_user_id) && !options.has_key?(:user_id)
          
            country = options.delete(:country)
            raise ActiveModel::MissingAttributeError.new("country") if country.blank?

            conn = establish_connection("/#{country}/api/v2/campaigns/#{campaign_id}", params: options)
          
            if block_given?
              conn.on_complete do |response|
                campaign = parse_campaign(country, response.body, options: options, includes: includes)
                yield campaign
              end
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              parse_campaign(country, response.body, options: options, includes: includes)
            end
          end
        
          def all(options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten
            raise ActiveModel::MissingAttributeError.new("user_id") if includes.include?(:share_by_user_id) && !options.has_key?(:user_id)
            
            country = options[:country]
            raise ActiveModel::MissingAttributeError.new("country") if country.blank?

            conn = establish_connection(all_path(options), params: options)
            
            if block_given?
              conn.on_complete do |response|
                campaigns = parse_all_campaigns(country, response.body, options: options, includes: includes)
                yield campaigns
              end          
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              parse_all_campaigns(country, response.body, options: options, includes: includes)
            end
          end
          
          def recommendations_for_user(user_id, options={})
            country = options.delete(:country)
            raise ActiveModel::MissingAttributeError.new("country") if country.blank?

            conn = establish_connection("/#{country}/api/v2/campaigns/user_recommendations/#{user_id}", params: options)
            
            if block_given?
              conn.on_complete do |response|
                campaigns = parse_all_campaigns(country, response.body, options: options)
                yield campaigns
              end          
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              parse_all_campaigns(country, response.body, options: options)
            end
          end
          
          def parse_all_campaigns(country, json, args={})
            args[:includes] ||= []
            args[:options] ||= {}
            campaigns = JSON.parse(json)["campaigns"].collect {|campaign| instantiate(campaign)}
            include_request_share_by_user_id(country, args[:options][:user_id], campaigns) if args[:includes].include?(:share_by_user_id) && !args[:options][:user_id].blank? && !campaigns.map(&:id).blank?
            campaigns
          end
          
          def parse_campaign(country, json, args={})
            args[:includes] ||= []
            args[:options] ||= {}
            campaign = instantiate(JSON.parse(json))
            include_request_share_by_user_id(country, args[:options][:user_id], [campaign]) if args[:includes].include?(:share_by_user_id) && !args[:options][:user_id].blank?
            campaign
          end
          
          private
          def all_path(options)
            country = options.delete(:country)
            raise ActiveModel::MissingAttributeError.new("country") if country.blank?

            ids = [options.delete(:ids)].flatten.compact
            path = "/#{country}/api/v2/campaigns"
            path += "?ids=#{ids.join(",")}" unless ids.empty?
            path
          end
        end
      end
    end
  end
end
