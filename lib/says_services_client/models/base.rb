module SaysServicesClient
  module Models
    class Base < Utils::Connection
      I18n.enforce_available_locales = true
      
      include ActiveModel::Serializers::JSON
      include ActiveModel::Validations
      include ActiveModel::Conversion
      include ActiveModel::MassAssignmentSecurity
      include SaysServicesClient::Utils::ClassLevelInheritableAttributes
      include SaysServicesClient::Utils::Crud
      
      inheritable_attributes :attributes
      # class level instance variable
      @attributes = []
      
      class << self
        # class level attr accessor
        attr_accessor :attributes
        
        def attr_accessor(*args)
          self.attributes = (self.attributes + args).uniq
          super *args
        end
        
        def attr_reader(*args)
          self.attributes = (self.attributes + args).uniq
          super *args
        end
      end
      
      # override AR#inspect to mimic the behavior
      def inspect
        inspection = if self.attributes
          self.attributes.collect{|name, value| "#{name}: \"#{value}\""}.compact.join(", ")
        else
          "not initialized"
        end
        "#<#{self.class} #{inspection}>"
      end
  
      def initialize(attributes=nil)
        @new_record = true
        self.attributes = attributes unless attributes.nil?
      end
      
      def self.instantiate(attributes=nil)
        @new_record = false
        model = self.allocate
        model.send(:assign_reader_attrs, attributes, as: :admin) if attributes
        model.assign_attributes(attributes, as: :admin) if attributes
        model
      end
      
      def new_record?
        @new_record
      end
      
      def valid?(context = nil)
        context ||= (new_record? ? :create : :update)
        output = super(context)
        errors.empty? && output
      end
  
      def attributes
        self.class.attributes.inject(ActiveSupport::HashWithIndifferentAccess.new) do |result, key|
          result[key] = read_attribute_for_validation(key)
          result
        end
      end

      def attributes=(attrs)
        sanitize_for_mass_assignment(attrs).each do |k, v|
          send("#{k}=", v)
        end
      end
      
      def assign_attributes(values, options={})
        sanitize_for_mass_assignment(values, options[:as]).each do |k, v|
          send("#{k}=", v)
        end
      end
              
      private
      def assign_reader_attrs(attributes, options={})
        attributes.each do |key, value|
          unless respond_to?("#{key}=")
            instance_variable_set("@#{key}", value)
            attributes.delete(key)
          end
        end
      end
    end
  end
end