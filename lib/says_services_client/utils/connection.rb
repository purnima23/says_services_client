module SaysServicesClient
  module Utils
    module Connection
      extend ActiveSupport::Concern
      
      module ClassMethods
        private
        def establish_connection(path, options={})
          cache_ttl = options[:params].try(:delete, :cache_ttl)
          options[:params] = {token: SaysServicesClient::Config.oauth_token}.merge(options[:params] || {})
          service_name = options.delete(:service_name)
          options[:cache_ttl] = cache_ttl if cache_ttl
          
          Typhoeus::Request.new(endpoint(service_name) + path, options)
        end
        
        def endpoint(custom_service_name=nil)
          raise MissingEndpoint.new("Missing #{custom_service_name || service_name} endpoint") unless SaysServicesClient::Config.endpoint.has_key?(custom_service_name || service_name)
          SaysServicesClient::Config.endpoint.fetch(custom_service_name || service_name)
        end
        
        def service_name
          "#{name.demodulize.underscore}_url".to_sym
        end
      end
    end
  end
end