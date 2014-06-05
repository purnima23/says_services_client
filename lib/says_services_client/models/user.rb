module SaysServicesClient
  class User < Models::Base  

    TIME_FIELDS = [:activated_at, :created_at, :updated_at, :dob]

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

    def self.find(user_id, options={})
      includes = Array(options.delete(:include)) || []
      country_code = options.delete(:country_code)

      conn = establish_connection("/api/admin/v1/users/#{user_id}")

      sociable_conn = nil
      if includes.include?(:sociable)
        raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?
        sociable_conn = establish_connection("/#{country_code}/api/admin/v1/users/#{user_id}", params: options.merge(uid: true), service_name: :sociable_user_url)
      end

      if block_given?
        conn.on_complete do |response|
          user = parse(response.body)

          if sociable_conn
            SaysServicesClient::Config.hydra.queue(sociable_conn)
            sociable_conn.on_complete do |response|
              yield parse(response.body).merge(user)
            end
          else
            yield user
          end
        end          
        SaysServicesClient::Config.hydra.queue(conn)
      else
        response = conn.run
        user = parse(response.body)

        if sociable_conn
          response = sociable_conn.run
          return parse(response.body).merge(user)
        end

        user
      end
    end

    def self.parse_list(json, options={})
      parsed = JSON.parse(json)
      parsed["users"].map { |u| parse(u) }
    end

    def self.parse(json, options={})
      json = JSON.parse(json) if json.is_a?(String)
      user = Hashie::Mash.new(json)

      TIME_FIELDS.each do |field|
        user[field] = Time.parse(user[field]) unless user[field].nil?
      end
      user
    end
  end
end