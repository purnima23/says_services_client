module SaysServicesClient
  module Utils
    module Cache
      class DalliClient
        def initialize
          @client = Dalli::Client.new(SaysServicesClient::Cache::Config.hosts, SaysServicesClient::Cache::Config.option)
        end
  
        def get(request)
          begin
            @client.get(request.cache_key)
          rescue Exception => e
            if SaysServicesClient::Cache::Config.raise_error
              raise e
            else
              Rails.logger.warn("Dalli memcached error: #{e}")
              nil
            end
          end
        end

        def set(request, response)
          begin
            @client.set(request.cache_key, response, request.cache_ttl)
          rescue Exception => e
            if SaysServicesClient::Cache::Config.raise_error
              raise e
            else
              Rails.logger.warn("Dalli memcached error: #{e}")
            end
          end
        end
      end
    end
  end
end