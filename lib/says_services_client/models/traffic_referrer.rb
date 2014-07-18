module SaysServicesClient
  class TrafficReferrer < Models::Base
    class << self
      def all(options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?
        
        super("/#{options[:country]}/api/admin/v1/traffic_referrers", params: options, service_name: :cashout_url)
      end
    end
  end
end
