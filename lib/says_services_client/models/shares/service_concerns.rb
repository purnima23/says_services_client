module SaysServicesClient
  module Models
    module Shares
      module ServiceConcerns
        extend ActiveSupport::Concern
  
        module ClassMethods
          def find_by_user_id(user_id, options={})
            conn = establish_connection(find_by_user_id_path(user_id, options), params: options)
          
            if block_given?
              conn.on_complete do |response|
                shares = JSON.parse(response.body).collect {|share| instantiate(share)}
                yield shares
              end
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              JSON.parse(response.body).collect {|share| instantiate(share)}
            end
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
