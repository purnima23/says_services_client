module SaysServicesClient
  module Models
    module Campaigns
      module StateConcerns
        extend ActiveSupport::Concern
  
        def abandoned?
          self.state == 'abandoned'
        end
        
        def draft?
          self.state == 'draft'
        end
        
        def ready?
          self.state == 'ready'
        end
        
        def paused?
          self.state == 'paused'
        end
        
        def scheduled?
          self.state == 'scheduled'
        end
      end
    end
  end
end
