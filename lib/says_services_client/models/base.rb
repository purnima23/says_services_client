module SaysServicesClient
  module Models
    class Base < Utils::Connection
      I18n.enforce_available_locales = true
      
      include ActiveModel::Serializers::JSON
      include ActiveModel::Validations
      include ActiveModel::Conversion
      include SaysServicesClient::Utils::ClassLevelInheritableAttributes
      include SaysServicesClient::Utils::OperationConcerns
      
      inheritable_attributes :attributes, :method_attributes
      # class level instance variable
      @attributes = []
      @method_attributes = []
      
      class << self
        # class level attr accessor
        attr_accessor :attributes, :method_attributes

        @@last_request = nil

        def last_request
          @@last_request
        end

        def last_request=(request)
          @@last_request = request
        end
        
        def attr_accessor(*args)
          self.attributes = (self.attributes + args).uniq
          super *args
        end
        
        def attr_reader(*args)
          self.attributes = (self.attributes + args).uniq
          self.method_attributes = (self.method_attributes + args).uniq
          super *args
        end
        
        def instantiate(attributes=nil)
          model = self.allocate
          model.send(:assign_reader_attrs, attributes, as: :admin) if attributes
          model.attributes = attributes if attributes
          model.instance_variable_set("@new_record", false)
          model
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
        attrs.each do |k, v|
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