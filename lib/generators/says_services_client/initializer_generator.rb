module SaysServicesClient
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      desc "This generator creates an initializer file at config/initializers"
      
      source_root File.expand_path('../templates', __FILE__)
      
      def create_initializer_file
        template "initializer.rb", File.join('config', 'initializers', 'says_services_client.rb')
      end
    end
  end
end