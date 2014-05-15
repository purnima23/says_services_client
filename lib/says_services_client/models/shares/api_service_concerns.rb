module SaysServicesClient
  module Models
    module Shares
      module ApiServiceConcerns
        extend ActiveSupport::Concern
  
        module ClassMethods
          def find_by_user_id(user_id, options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten
            
            conn = establish_connection(find_by_user_id_path(user_id, options), params: options)
          
            if block_given?
              conn.on_complete do |response|
                shares = parse_all_shares(response.body, options: options, includes: includes)
                yield shares
              end
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              parse_all_shares(response.body, options: options, includes: includes)
            end
          end
          
          def find(id, options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten
            
            conn = establish_connection("/api/v2/shares/#{id}", params: options)
          
            if block_given?
              conn.on_complete do |response|
                if response.response_code == 404
                  yield nil
                else
                  yield parse_share(response.body, options: options, includes: includes)
                end
              end
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              return nil if response.response_code == 404
              parse_share(response.body, options: options, includes: includes)
            end
          end

          def parse_all_shares(json, args={})
            args[:includes] ||= []
            args[:options] ||= {}
            shares = JSON.parse(json)["shares"].collect {|share| instantiate(share)}
            include_shared_campaign(shares) if args[:includes].include?(:campaign) && !shares.empty?
            shares
          end
          
          def parse_share(json, args={})
            args[:includes] ||= []
            args[:options] ||= {}
            share = instantiate(JSON.parse(json))
            include_shared_campaign([share]) if args[:includes].include?(:campaign)
            share
          end
          
          private
          def find_by_user_id_path(user_id, options)
            path = "/api/v2/shares/users/#{user_id}"
            campaign_ids = [options.symbolize_keys!.delete(:campaign_ids)].flatten.compact
            campaign_ids.empty? ? path : "#{path}?campaign_ids=#{campaign_ids.join(",")}"
          end
        end
      end
    end
  end
end
