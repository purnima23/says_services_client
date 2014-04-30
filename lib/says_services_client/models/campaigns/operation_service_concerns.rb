module SaysServicesClient
  module Models
    module Campaigns
      module OperationServiceConcerns
        extend ActiveSupport::Concern
  
        private
        def update(options={})
          hash = self.attributes.clone.dup
          # protected = ['id', 'type', 'created_at', 'updated_at']
          hash.delete("type")
          hash.delete("id")
          hash = hash.select{|k, v| !self.class.method_attributes.include?(k.to_sym)}
          conn = self.class.send(:establish_connection, "api/v2/campaigns/#{id}", method: :put, params: {campaign: hash})
          
          response = conn.run
          attrs = JSON.parse(response.body)
          attrs['errors'].each do |e|
            self.errors.add(e.first, e.last)
          end unless attrs['saved'] == true
          attrs['saved']
        end
      end
    end
  end
end