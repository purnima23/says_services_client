module SaysServicesClient
  class RewardStore < Models::Base
    class << self
      def all(options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?

        super("/#{options[:country]}/api/v2/reward_stores", params: options, service_name: :share_stat_url)
      end
    end
  end
end