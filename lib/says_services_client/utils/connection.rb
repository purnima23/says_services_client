module SaysServicesClient
  module Utils
    class Connection
      class << self
        private
        def establish_connection(path, options={})
          options[:params] = {token: SaysServicesClient::Config.oauth_token}.merge(options[:params] || {})
          Typhoeus::Request.new(endpoint + path, options)
        end
        
        def endpoint
          raise MissingEndpoint.new("Missing #{service_name} endpoint") unless SaysServicesClient::Config.endpoint.has_key?(service_name)
          SaysServicesClient::Config.endpoint.fetch(service_name)
        end
        
        def service_name
          "#{name.demodulize.underscore}_url".to_sym
        end
      end
    end
  end
end