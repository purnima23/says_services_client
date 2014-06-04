# require 'says_services_client/models/users/api_service_concerns'

module SaysServicesClient
  class User < Models::Base  

    def self.all(options={})      
      conn = establish_connection("/api/admin/v1/users", params: options)
      
      if block_given?
        conn.on_complete do |response|
          users = parse_list(response.body, options: options)
          yield users
        end          
        SaysServicesClient::Config.hydra.queue(conn)
      else
        response = conn.run
        parse_list(response.body, options: options)
      end
    end

    def self.find(user_id)
      conn = establish_connection("/api/admin/v1/users/#{user_id}")

      if block_given?
        conn.on_complete do |response|
          user = parse(response.body)
          yield user
        end          
        SaysServicesClient::Config.hydra.queue(conn)
      else
        response = conn.run
        parse(response.body)
      end
    end

    def self.parse_list(json, options={})
      parsed = JSON.parse(json)
      parsed["users"].map { |u| parse(u) }
    end

    def self.parse(json, options={})
      json = JSON.parse(json) if json.is_a?(String)
      user = Hashie::Mash.new(json)
      user.activated_at = Time.parse(user.activated_at) unless user.activated_at.nil?
      user
    end
  end
end