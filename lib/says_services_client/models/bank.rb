module SaysServicesClient
  class Bank < Models::Base
    class << self
      def all(country_code, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?

        super("/api/admin/v1/countries/#{country_code}/banks", params: options, service_name: :user_url)
      end
    end
  end
end
