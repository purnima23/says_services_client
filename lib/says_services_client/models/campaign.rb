require 'says_services_client/models/campaigns/state_concerns'
require 'says_services_client/models/campaigns/api_service_concerns'
require 'says_services_client/models/campaigns/share_concerns'
require 'says_services_client/models/campaigns/operation_service_concerns'

module SaysServicesClient
  class Campaign < Models::Base
    include SaysServicesClient::Models::Campaigns::StateConcerns
    include SaysServicesClient::Models::Campaigns::ApiServiceConcerns
    include SaysServicesClient::Models::Campaigns::ShareConcerns
    include SaysServicesClient::Models::Campaigns::OperationServiceConcerns

    attr_reader :friendly_id, :is_ended, :is_completed, :remaining_days, :total_available_reward, :per_uv_reward, :site_url, :photo_url, :large_photo_url, :site_screenshot_url, :triggers, :tag_list, :requirement, :country, :reward_count, :total_reward, :click_limit, :preview_key
    attr_accessor :id, :title, :campaign_about, :supporters_count, :views_count, :completed_at, :created_at, :updated_at, :state, :type, :no_facebook_sharing, :reward_type, :secondary_description

    validates_presence_of :title

    alias_method :is_completed?, :is_completed
    alias_method :is_ended?, :is_ended
    alias_method :no_facebook_sharing?, :no_facebook_sharing

    def triggers=(trigger_attributes)
      @triggers = []
      trigger_attributes.each do |attr|
        @triggers.push(SaysServicesClient::Trigger.instantiate(attr))
      end
    end

    def is_cash?
      reward_type == "Cash"
    end

    def is_bp?
      reward_type == "Contribution Point"
    end
  end
end
