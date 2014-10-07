module SaysServicesClient
  module Cache
    class Config
      class << self
        attr_accessor :hosts, :option, :raise_error
      
        def option
          @option || {}
        end
        
        def raise_error
          @raise_error.nil? ? true : @raise_error
        end
      end
    end
  end
end