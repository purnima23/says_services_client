module SaysServicesClient
  class Job < Models::Base
    class << self

      def create(country_code, options={}, &block)
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?

        path = "/#{country_code}/api/admin/v1/jobs"
        options = {method: :post, params: options, service_name: :sociable_user_url}

        run_request(:object, path, options, &block)
      end

      def find(country_code, id, &block)
        raise ActiveModel::MissingAttributeError.new("country_code") if country_code.blank?

        path = "/#{country_code}/api/admin/v1/jobs/#{id}"
        options = {service_name: :sociable_user_url}

        run_request(:object, path, options, &block)
      end
    end
  end
end
