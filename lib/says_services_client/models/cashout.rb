module SaysServicesClient
  class Cashout < Models::Base

    TIME_FIELDS = [:created_at, :updated_at]

    def self.all(options={})
      country_code = options.delete(:country_code)
      raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?

      conn = establish_connection("/#{country_code}/api/admin/v1/cashouts", params: options)
      
      if block_given?
        conn.on_complete do |response|
          cashouts = parse_list(response.body, options)
          yield cashouts
        end          
        SaysServicesClient::Config.hydra.queue(conn)
      else
        response = conn.run
        parse_list(response.body, options)
      end
    end

    def self.update(id, options={})
      country_code = options.delete(:country_code)
      raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?
      raise ActiveModel::MissingAttributeError.new("id") if id.blank?
      raise ActiveModel::MissingAttributeError.new("update_action") if options[:update_action].blank?

      request = establish_connection("/#{country_code}/api/admin/v1/cashouts/#{id}", method: :put, params: options)
      response = request.run
      parse(response.body)
    end

    def self.update_all(options={})
      country_code = options.delete(:country_code)
      raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?
      raise ActiveModel::MissingAttributeError.new("update_action") if options[:update_action].blank?

      request = establish_connection("/#{country_code}/api/admin/v1/cashouts/update_all", method: :put, params: options)
      response = request.run
      parse(response.body)
    end

    protected

    def self.parse_list(json, options={})
      parsed = JSON.parse(json)
      cashouts = parsed.delete("cashouts").map { |u| parse(u) }

      page     = parsed.delete("page") || 1
      per_page = parsed.delete("per_page") || 15
      total    = parsed.delete("total_entries") || cashouts.length
      
      last_request = Hashie::Mash.new
      parsed.keys.each do |key|
        last_request[key] = parsed[key]
      end
      self.last_request = last_request

      WillPaginate::Collection.create(page, per_page, total) do |pager|
        pager.replace cashouts
      end
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