module SaysServicesClient
  module Utils
    module ClassLevelInheritableAttributes
      def self.included(base)
        base.extend(ClassMethods)    
      end
  
      module ClassMethods
        def inheritable_attributes(*args)
          @inheritable_attributes ||= [:inheritable_attributes]
          @inheritable_attributes += args
          args.each do |arg|
            class_eval %(
              class << self; attr_accessor :#{arg} end
            )
          end
          @inheritable_attributes
        end
    
        # Whenever a class that has included this module gets subclassed, it sets a class level instance variable for each of the declared class level inheritable instance variables 
        def inherited(subclass)
          @inheritable_attributes.each do |inheritable_attribute|
            instance_var = "@#{inheritable_attribute}"
            subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
          end
        end
      end
    end
  end
end