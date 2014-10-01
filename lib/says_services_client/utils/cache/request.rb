module SaysServicesClient
  module Utils
    module Cache
      module Request
        def self.included base
          base.class_eval do
            def cacheable?
              cache_ttl && Typhoeus::Config.cache
            end
          end
        end
      end
    end
  end
end