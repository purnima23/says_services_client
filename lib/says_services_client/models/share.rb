require 'says_services_client/models/shares/shared_campaign_concerns'

module SaysServicesClient
  class Share < Models::Base
    include SaysServicesClient::Models::Shares::SharedCampaignConcerns
        
    validates_presence_of :user_id, on: :create
    validates_presence_of :campaign_id, on: :create
    validates_presence_of :username, on: :create
    validates_presence_of :message, on: :create
    
    def fresh
      fresh ||= false
    end
    
    def next_page?
      offset > 0
    end
    
    class << self
      def find(id, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?
        
        super("/#{options[:country]}/api/v2/shares/#{id}", params: options)
      end
      
      def find_by_user_id(user_id, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?
      
        conn = establish_connection(find_by_user_id_path(user_id, options), params: options)
      
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
      def find_by_user_id_path(user_id, options)
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?

        path = "/#{options[:country]}/api/v2/shares/users/#{user_id}"
        campaign_ids = [options.symbolize_keys!.delete(:campaign_ids)].flatten.compact
        campaign_ids.empty? ? path : "#{path}?campaign_ids=#{campaign_ids.join(",")}"
      end
    end
    
    private
    def create!(options={})
      raise ActiveModel::MissingAttributeError.new("country") if country_code.blank?
      post!("/#{country_code}/api/v2/shares/campaigns/#{campaign_id}/users/#{user_id}", options.merge!(params: to_hash))      
    end
  end
end