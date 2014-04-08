module SaysServicesClient
  module Utils
    module Crud
      extend ActiveSupport::Concern
      
      def update
        conn = self.class.send(:establish_connection, "/api/v2/campaigns/#{self.id}", method: :put, params: {campaign: self.attributes})
        # conn = self.class.send(:establish_connection, "/api/v2/campaigns/#{self.id}", method: :put, body: {campaign: self.attributes})
        response = conn.run
        
        if response.code == 200
          return self
        else
          errors.add(:http_code, response.code)
          errors.add(:http_response_body, response.body)
          return nil
        end
      end
    end
  end
end