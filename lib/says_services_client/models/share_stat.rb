require 'says_services_client/models/share_stats/api_service_concerns'

module SaysServicesClient
  class ShareStat < Models::Base
    include SaysServicesClient::Models::ShareStats::ApiServiceConcerns
    
    attr_reader :total_rewarded_uv_count
  end
end