module SaysServicesClient
  module Models
    class Base < Utils::Connection
      include ActiveModel::Serializers::JSON
      include ActiveModel::Validations
      include ActiveModel::Conversion
      include ActiveModel::MassAssignmentSecurity
      include SaysServicesClient::Utils::Crud
  
      def initialize(attributes={})
        self.send(:dynamic_methods, attributes)
        self.attributes = attributes
      end
  
      def attributes
        self.class::ATTRIBUTES.inject(ActiveSupport::HashWithIndifferentAccess.new) do |result, key|
          result[key] = read_attribute_for_validation(key)
          result
        end
      end

      def attributes=(attrs)
        sanitize_for_mass_assignment(attrs).each_pair {|k, v| send("#{k}=", v)}
      end
              
      private
      def dynamic_methods(attributes)
        attributes.each do |key, value|
          unless self.class::ATTRIBUTES.include?(key)
            instance_variable_set("@#{key}", value)
            self.class.send(:define_method, key) {instance_variable_get("@#{key}")} unless respond_to?(key)
            attributes.delete(key)
          end
        end
      end
    end
  end
end