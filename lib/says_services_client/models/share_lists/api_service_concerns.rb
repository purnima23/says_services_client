module SaysServicesClient
  module Models
    module ShareLists
      module ApiServiceConcerns
        extend ActiveSupport::Concern
  
        module ClassMethods
          def find_by_user_id(user_id, options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten

            country = options.delete(:country)
            raise ActiveModel::MissingAttributeError.new("country") if country.blank?
          
            conn = establish_connection("/#{country}/api/v2/shares/users/#{user_id}", params: options)
          
            if block_given?
              conn.on_complete do |response|
                shares = SaysServicesClient::Share.parse_all_shares(country, response.body, options: options, includes: includes)
                list = instantiate(offset: JSON.parse(response.body)["offset"], shares: shares)
                yield list
              end          
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              shares = SaysServicesClient::Share.parse_all_shares(country, response.body, options: options, includes: includes)
              instantiate(offset: JSON.parse(response.body)["offset"], shares: shares)
            end
          end
        end
      end
    end
  end
end
