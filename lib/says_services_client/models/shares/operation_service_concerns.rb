module SaysServicesClient
  module Models
    module Shares
      module OperationServiceConcerns
        extend ActiveSupport::Concern
  
        private
        def create_operation_service(options={})
          options[:username] ||= username
          options[:message] ||= message
          conn = self.class.send(:establish_connection, "api/v2/shares/campaigns/#{campaign_id}/users/#{user_id}", method: :post, params: options)
          
          response = conn.run
          attrs = JSON.parse(response.body)
          assign_reader_attrs(attrs)
          self.attributes = attrs
          @new_record = false if id
          !id.blank?
        end
      end
    end
  end
end