module SaysServicesClient
  class User < Models::Base

    TIME_FIELDS = [:activated_at, :created_at, :updated_at, :dob]

    def self.all(options={})

      source = options.delete(:source)
      service_name = :user_url
      path = "/api/admin/v1/users"
      if "sociable" == source
        service_name = :sociable_user_url
        country = options.delete(:country)
        path = "/#{country}#{path}"
      end

      conn = establish_connection(path, service_name: service_name, params: options)

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

      source = options.delete(:source)
      service_name = :user_url
      path = "/api/admin/v1/users"
      if "sociable" == source.to_s
        service_name = "vn" == country_code ? :sociable_vn_user_url : :sociable_user_url
        path = "/#{country_code}#{path}"
      end

      conn = establish_connection("#{path}/#{user_id}", service_name: service_name)

      sociable_conn = nil
      if includes.include?(:sociable)
        raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?
        service_name = "vn" == country_code ? :sociable_vn_user_url : :sociable_user_url
        sociable_conn = establish_connection("/#{country_code}/api/admin/v1/users/#{user_id}", params: options.merge(uid: true), service_name: service_name)
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

   def self.update(id, options={})
      raise ActiveModel::MissingAttributeError.new("id") if id.blank?

      source = options.delete(:source)

      if "sociable" == source
        country_code = options.delete(:country)
        service_name = "vn" == country_code ? :sociable_vn_user_url : :sociable_user_url
        path = "/#{country_code}/api/admin/v1/users/#{id}"
      else
        service_name = :user_url
        path = "/api/admin/v1/users/#{id}"
      end
      request = establish_connection(path, service_name: service_name, method: :put, params: options)
      response = request.run
      parse(response.body)
    end


    def self.suspend(id, options={})
      raise ActiveModel::MissingAttributeError.new("id") if id.blank?


    end

    def self.parse_list(json, options={})
      parsed = JSON.parse(json)
      users = parsed["users"].map { |u| parse(u) }

      page     = parsed["page"] || 1
      per_page = parsed["per_page"] || 15
      total    = parsed["total_entries"] || users.length

      WillPaginate::Collection.create(page, per_page, total) do |pager|
        pager.replace users
      end
    end

    def self.parse(json, options={})
      json = JSON.parse(json) if json.is_a?(String)
      user = Hashie::Mash.new(json)

      TIME_FIELDS.each do |field|
        user[field] = Time.parse(user[field]) unless user[field].nil?
      end
      user
    end

    def self.renew_invite_url(user_id, options={})
      country_code = options.delete(:country_code)
      service_name = "vn" == country_code ? :sociable_vn_user_url : :sociable_user_url
      conn = establish_connection("/#{country_code}/api/admin/v1/invites/renew?id=#{user_id}", service_name: service_name)

      response = conn.run
      JSON.parse(response.body)['url']
    end

    def self.custom_reward(options={})
      country_code = options.delete(:country_code)

      raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?
      raise ActiveModel::MissingAttributeError.new("type") if options[:type].blank?
      raise ActiveModel::MissingAttributeError.new("user") if options[:user].blank?
      raise ActiveModel::MissingAttributeError.new("reward_type") if options[:reward_type].blank?
      raise ActiveModel::MissingAttributeError.new("remark") if options[:remark].blank?
      raise ActiveModel::MissingAttributeError.new("amount") if options[:amount].blank?
      raise ActiveModel::MissingAttributeError.new("transactable_type") if options[:transactable_type].blank?
      raise ActiveModel::MissingAttributeError.new("transactable_id") if options[:transactable_id].blank?
      raise ActiveModel::MissingAttributeError.new("whodunnit") if options[:whodunnit].blank?

      path = "/#{country_code}/api/admin/v1/users/custom_rewards"
      conn = establish_connection("#{path}", service_name: :sociable_user_url, method: :post, params: options)

      if block_given?
        conn.on_complete do |response|
          yield parse(response.body)
        end
        SaysServicesClient::Config.hydra.queue(conn)
      else
        response = conn.run
        parse(response.body)
      end
    end
  end
end
