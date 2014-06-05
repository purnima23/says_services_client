module SaysServicesClient
  class Cashout < Models::Base

    TIME_FIELDS = [:created_at, :updated_at]

    def self.all(options={})
      country_code = options.delete(:country_code)
      raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?

      conn = establish_connection("/#{country_code}/api/admin/v1/cashouts", params: options)
      
      if block_given?
        conn.on_complete do |response|
          cashouts = parse_list(response.body)
          yield cashouts
        end          
        SaysServicesClient::Config.hydra.queue(conn)
      else
        response = conn.run
        parse_list(response.body)
      end
    end

    def self.parse_list(json)
      parsed = JSON.parse(json)
      parsed["cashouts"].map { |u| parse(u) }
    end

    def self.parse(json)
      json = JSON.parse(json) if json.is_a?(String)
      cashout = Hashie::Mash.new(json)

      TIME_FIELDS.each do |field|
        cashout[field] = Time.parse(cashout[field]) unless cashout[field].nil?
      end
      cashout
    end
  end
end