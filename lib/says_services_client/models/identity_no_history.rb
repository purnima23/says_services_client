module SaysServicesClient
  class IdentityNoHistory < Models::Base
    class << self    
      def all(user_id, options={})
        options.symbolize_keys!
        super("/api/admin/v1/users/#{user_id}/identity_no_histories", params: options, service_name: :user_url)
      end
    end
  end
end