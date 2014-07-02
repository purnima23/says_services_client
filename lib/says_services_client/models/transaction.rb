module SaysServicesClient
  class Transaction < Models::Base

    TIME_FIELDS = [:created_at, :updated_at]

    def self.all(options={})
      country_code = options.delete(:country_code)
      raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?

      user_id = options.delete(:user_id)
      raise ActiveModel::MissingAttributeError.new("user_id") if user_id.blank?

      conn = establish_connection("/#{country_code}/api/admin/v1/users/#{user_id}/transactions", params: options)
      
      if block_given?
        conn.on_complete do |response|
          transactions = parse_list(response.body, options)
          yield transactions
        end          
        SaysServicesClient::Config.hydra.queue(conn)
      else
        response = conn.run
        parse_list(response.body, options)
      end
    end

    protected

    def self.parse_list(json, options={})
      parsed = JSON.parse(json)
      transactions = parsed.delete("transactions").map { |u| parse(u) }

      page     = parsed.delete("page") || 1
      per_page = parsed.delete("per_page") || 15
      total    = parsed.delete("total_entries") || transactions.length
      
      last_request = Hashie::Mash.new
      parsed.keys.each do |key|
        last_request[key] = parsed[key]
      end
      self.last_request = last_request

      WillPaginate::Collection.create(page, per_page, total) do |pager|
        pager.replace transactions
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