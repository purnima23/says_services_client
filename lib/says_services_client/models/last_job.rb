module SaysServicesClient
  class LastJob < Models::Base
    def self.find(name, options={})
      country = options.delete(:country)
      raise ActiveModel::MissingAttributeError.new("country") if country.blank?
      
      conn = establish_connection("/#{country}/api/v2/last_job/#{name}", params: options)
      
      if block_given?
        conn.on_complete do |response|
          json = JSON.parse(response.body)
          yield Hashie::Mash.new(json)
        end          
        SaysServicesClient::Config.hydra.queue(conn)
      else
        response = conn.run
        json = JSON.parse(response.body)
        Hashie::Mash.new(json)
      end
    end
  end
end