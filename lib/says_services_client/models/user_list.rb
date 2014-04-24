require 'says_services_client/models/user_lists/api_service_concerns'

module SaysServicesClient
  class UserList < Models::Base
    include SaysServicesClient::Models::UserLists::ApiServiceConcerns
    
    attr_reader :users, :total_pages, :current_page
  end
end