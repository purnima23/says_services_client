module SaysServicesClient
  module Models
    module CampaignLists
      module ApiServiceConcerns
        extend ActiveSupport::Concern
  
        module ClassMethods
          def for(options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten
            raise ActiveModel::MissingAttributeError.new("user_id") if includes.include?(:share_by_user_id) && !options.has_key?(:user_id)

            country = options.delete(:country)
            raise ActiveModel::MissingAttributeError.new("country") if country.blank?
          
            conn = establish_connection("/#{country}/api/v2/campaigns", params: options)
          
            if block_given?
              conn.on_complete do |response|
                campaigns = SaysServicesClient::Campaign.parse_all_campaigns(country, response.body, options: options, includes: includes)
                list = instantiate(offset: JSON.parse(response.body)["offset"], campaigns: campaigns)
                yield list
              end          
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              campaigns = SaysServicesClient::Campaign.parse_all_campaigns(country, response.body, options: options, includes: includes)
              instantiate(offset: JSON.parse(response.body)["offset"], campaigns: campaigns)
            end
          end
        end
      end
    end
  end
end
