module SaysServicesClient
  class LastJob < Models::Base
    class << self
      def find(name, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?

        super("/#{options[:country]}/api/v2/last_job/#{name}", params: options)
      end
    end
  end
end