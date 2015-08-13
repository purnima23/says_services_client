module SaysServicesClient
  class Gamification < Models::Base
    validates_presence_of :user_id

    class << self
      def self.get_level(user_id, options={})
        options.symbolize_keys!
        options[:user_id] = user_id
        super("/#{options[:country_code]}/api/v2/gamifications/level", params: options, service_name: :campaign_url)
      end
    end

  end
end
