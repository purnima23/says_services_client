module SaysServicesClient
  module Models
    module Shares
      module ApiServiceConcerns
        extend ActiveSupport::Concern
  
        module ClassMethods
          def find_by_user_id(user_id, options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten
            
            country = options[:country]
            raise ActiveModel::MissingAttributeError.new("country") if country.blank?

            conn = establish_connection(find_by_user_id_path(user_id, options), params: options)
          
            if block_given?
              conn.on_complete do |response|
                shares = parse_all_shares(country, response.body, options: options, includes: includes)
                yield shares
              end
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              parse_all_shares(country, response.body, options: options, includes: includes)
            end
          end
          
          def find(id, options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten
            
            country = options.delete(:country)
            raise ActiveModel::MissingAttributeError.new("country") if country.blank?

            conn = establish_connection("/#{country}/api/v2/shares/#{id}", params: options)
          
            if block_given?
              conn.on_complete do |response|
                if response.response_code == 404
                  yield nil
                else
                  yield parse_share(country, response.body, options: options, includes: includes)
                end
              end
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              return nil if response.response_code == 404
              parse_share(country, response.body, options: options, includes: includes)
            end
          end

          def parse_all_shares(country, json, args={})
            args[:includes] ||= []
            args[:options] ||= {}
            shares = JSON.parse(json)["shares"].collect {|share| instantiate(share)}
            include_shared_campaign(country, shares) if args[:includes].include?(:campaign) && !shares.empty?
            shares
          end
          
          def parse_share(country, json, args={})
            args[:includes] ||= []
            args[:options] ||= {}
            share = instantiate(JSON.parse(json))
            include_shared_campaign(country, [share]) if args[:includes].include?(:campaign)
            share
          end
          
          private
          def find_by_user_id_path(user_id, options)
            country = options.delete(:country)
            raise ActiveModel::MissingAttributeError.new("country") if country.blank?

            path = "/#{country}/api/v2/shares/users/#{user_id}"
            campaign_ids = [options.symbolize_keys!.delete(:campaign_ids)].flatten.compact
            campaign_ids.empty? ? path : "#{path}?campaign_ids=#{campaign_ids.join(",")}"
          end
        end
      end
    end
  end
end
