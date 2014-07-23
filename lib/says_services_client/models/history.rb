module SaysServicesClient
  class History < Models::Base
    validates_presence_of :action_taken, :user_id, :remarks
    
    class << self    
      def all(user_id, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country_code") if options[:country_code].blank?
        
        super("/#{options[:country_code]}/api/admin/v1/users/#{user_id}/histories", params: options, service_name: :sociable_user_url)
      end
    end
    
    private
    def create!(options={})
      raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?
      post!("/#{country_code}/api/admin/v1/users/#{user_id}/histories", options.merge!(body: {history: to_hash}, service_name: :sociable_user_url))      
    end
  end
end
