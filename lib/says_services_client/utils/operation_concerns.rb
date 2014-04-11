module SaysServicesClient
  module Utils
    module OperationConcerns
      extend ActiveSupport::Concern
      
      # def update
      #   conn = self.class.send(:establish_connection, "/api/v2/campaigns/#{self.id}", method: :put, params: {campaign: self.attributes})
      #   # conn = self.class.send(:establish_connection, "/api/v2/campaigns/#{self.id}", method: :put, body: {campaign: self.attributes})
      #   response = conn.run
      #   
      #   if response.code == 200
      #     return self
      #   else
      #     errors.add(:http_code, response.code)
      #     errors.add(:http_response_body, response.body)
      #     return nil
      #   end
      # end
      
      module ClassMethods
        def create(attributes=nil, options={})
          object = new(attributes)
          object.save
          object
        end
      end
      
      def save
        create_or_update
      end
      
      private
      def create_operation_service
        raise NotImplementedError #implement in subclass
      end
      
      def create_or_update
        result = new_record? ? create : update
        result != false
      end
      
      def create
        if valid?
          create_operation_service
        else
          false
        end
      end
      
      def update
        raise NotImplementedError #implement in subclass
      end
    end
  end
end