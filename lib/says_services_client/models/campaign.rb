require 'says_services_client/models/campaigns/state_concerns'
require 'says_services_client/models/campaigns/share_concerns'

module SaysServicesClient
  class Campaign < Models::Base
    TIME_FIELDS = [:created_at, :updated_at, :announce_date]
    
    include SaysServicesClient::Models::Campaigns::StateConcerns
    include SaysServicesClient::Models::Campaigns::ShareConcerns

    validates_presence_of :title
    
    def is_cash?
      reward_type == "Cash"
    end

    def is_bp?
      reward_type == "Contribution Point"
    end
    
    def next_page?
      offset > 0
    end
    
    class << self
      def find(campaign_id, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("user_id") if [options[:include]].include?(:share_by_user_id) && options.try(:fetch, :user_id, nil).blank?
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?

        super("/#{options[:country]}/api/v2/campaigns/#{campaign_id}", params: options)
      end
      
      def all(options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("user_id") if [options[:include]].include?(:share_by_user_id) && options.try(:fetch, :user_id, nil).blank?
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?

        super(all_path(options), params: options)
      end
      
      def recommendations_for_user(user_id, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?

        conn = establish_connection("/#{options[:country]}/api/v2/campaigns/user_recommendations/#{user_id}", params: options)
        
        if block_given?
          conn.on_complete do |response|
            yield parse_list!(response, options)
          end          
          SaysServicesClient::Config.hydra.queue(conn)
        else
          response = conn.run
          parse_list!(response, options)
        end
      end
      
      private
      def all_path(options)
        ids = [options.delete(:ids)].flatten.compact
        path = "/#{options[:country]}/api/v2/campaigns"
        path += "?ids=#{ids.join(",")}" unless ids.empty?
        path
      end
    end
  end
end
