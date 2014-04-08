module SaysServicesClient
  module Utils
    class Connection
      class << self
        private
        def establish_connection(path, options={})
          options[:params] = {token: SaysServicesClient::Config.oauth_token}.merge(options[:params] || {})
          Typhoeus::Request.new(endpoint + path, options)
        end
        
        # raise error if no endpoint
        def endpoint
          SaysServicesClient::Config.endpoint.has_key?(service_name) ? SaysServicesClient::Config.endpoint.fetch(service_name) : nil
        end
        
        def service_name
          "#{name.demodulize.underscore}_url".to_sym
        end
      end
    end
  end
end