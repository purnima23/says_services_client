module SaysServicesClient
  class TrafficReferrer < Models::Base
    def self.all(options={})
      country = options.delete(:country)
      raise ActiveModel::MissingAttributeError.new("country") if country.blank?
      
      service_name = :cashout_url
      path = "/#{country}/api/admin/v1/traffic_referrers"

      conn = establish_connection(path, service_name: service_name, params: options)

      if block_given?
        conn.on_complete do |response|
          yield parse_list(response.body, options: options)
        end
        SaysServicesClient::Config.hydra.queue(conn)
      else
        response = conn.run
        parse_list(response.body, options: options)
      end
    end

    def self.parse_list(json, options={})
      parsed = JSON.parse(json)
      traffic_referrers = parsed["traffic_referrers"].map {|r| parse(r)}

      page     = parsed["page"]
      per_page = parsed["per_page"]
      total    = parsed["total_entries"]

      WillPaginate::Collection.create(page, per_page, total) do |pager|
        pager.replace traffic_referrers
      end
    end

    def self.parse(json, options={})
      json = JSON.parse(json) if json.is_a?(String)
      Hashie::Mash.new(json)
    end
  end
end
