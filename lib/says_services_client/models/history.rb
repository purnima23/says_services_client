module SaysServicesClient
  class History < Models::Base
    TIME_FIELDS = [:created_at, :updated_at]

    class << self    
      def all(user_id, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country_code") if options[:country_code].blank?
        
        super("/#{options[:country_code]}/api/admin/v1/users/#{user_id}/histories", params: options, service_name: :sociable_user_url)
      end
    end
    
    private
    def create_operation_service(options={})
      raise ActiveModel::MissingAttributeError.new("country_code") if options[:country_code].blank?
      raise ActiveModel::MissingAttributeError.new("user_id") if options[:user_id].blank?
      
      conn = self.class.send(:establish_connection, "/#{country_code}/api/admin/v1/users/#{user_id}/histories", method: :post, params: options)
      response = conn.run
      
      json = JSON.parse(response.body)
      history = Hashie::Mash.new(json)
      !history.id.blank?
    end
  end
end
