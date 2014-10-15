module SaysServicesClient
  class RewardStore < Models::Base
    class << self
      def all(options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?

        super("/#{options[:country]}/api/v2/reward_stores", params: options, service_name: :share_stat_url)
      end
      
      def find(id, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?

        super("/#{options[:country]}/api/v2/reward_stores/#{id}", params: options, service_name: :share_stat_url)
      end
      
      def update(id, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?
        
        request = establish_connection("/#{options[:country]}/api/v2/reward_stores/#{id}", service_name: :share_stat_url, method: :put, params: options)
        response = request.run
        parse!(response)
      end
    end
  end
end