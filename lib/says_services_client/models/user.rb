# require 'says_services_client/models/users/api_service_concerns'

module SaysServicesClient
  class User < Models::Base
    # include SaysServicesClient::Models::Users::ApiServiceConcerns
    
    attr_reader :super_admin, :display_name, :profile_img_url, :country
    attr_accessor :id, :email, :nickname, :notification_setting, :created_at, :updated
  end
end