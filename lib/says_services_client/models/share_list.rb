require 'says_services_client/models/share_lists/api_service_concerns'

module SaysServicesClient
  module Models
    class ShareList < Base
      include SaysServicesClient::Models::ShareLists::ApiServiceConcerns
      
      attr_reader :offset, :shares
    end
  end
end