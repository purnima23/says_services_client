module SaysServicesClient
  module Utils
    class Connection
      class << self
        private
        def establish_connection(path, options={})
          options[:params] = {token: SaysServicesClient::Config.oauth_token}.merge(options[:params] || {})
          service_name = options.delete(:service_name)
          Typhoeus::Request.new(endpoint(service_name) + path, options)
        end
        
        def endpoint(custom_service_name=nil)
          raise MissingEndpoint.new("Missing #{service_name} endpoint") unless SaysServicesClient::Config.endpoint.has_key?(service_name)
          SaysServicesClient::Config.endpoint.fetch(custom_service_name || service_name)
        end
        
        def service_name
          "#{name.demodulize.underscore}_url".to_sym
        end
      end
    end
  end
end