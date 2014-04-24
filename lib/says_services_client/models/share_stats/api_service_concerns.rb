module SaysServicesClient
  module Models
    module ShareStats
      module ApiServiceConcerns
        extend ActiveSupport::Concern
  
        module ClassMethods
          def find_by_user(id, options={})
            conn = establish_connection("/api/v2/share_stats/#{id}", params: options)
          
            if block_given?
              conn.on_complete do |response|
                if response.response_code == 404
                  yield nil
                else
                  yield parse_share_stat(response.body, options: options)
                end
              end
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              return nil if response.response_code == 404
              parse_share_stat(response.body, options: options)
            end
          end
          
          def parse_share_stat(json, args={})
            instantiate(JSON.parse(json))
          end
        end
      end
    end
  end
end
