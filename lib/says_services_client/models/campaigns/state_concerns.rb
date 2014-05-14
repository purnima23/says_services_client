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
        
        def active?
          self.state == 'active'
        end
        
        def completed?
          self.state == 'completed'
        end
        
        def archiving?
          self.state == 'archiving'
        end
        
        def archived?
          self.state == 'archived'
        end
        
        def abandoned?
          self.state == 'abandoned'
        end
      end
    end
  end
end
