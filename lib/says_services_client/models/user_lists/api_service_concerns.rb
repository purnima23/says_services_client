module SaysServicesClient
  module Models
    module UserLists
      module ApiServiceConcerns
        extend ActiveSupport::Concern
  
        module ClassMethods
          def all(options={})
            includes = [options.symbolize_keys!.delete(:include) || []].flatten
            
            conn = establish_connection("/api/v2/users", params: options)
            
            if block_given?
              conn.on_complete do |response|
                users = parse(JSON.parse(response.body)['users'], options: options, includes: includes)
                yield users
              end          
              SaysServicesClient::Config.hydra.queue(conn)
            else
              response = conn.run
              parse(JSON.parse(response.body), options: options, includes: includes)
            end
          end
          
          def parse(users, args={})
            args[:includes] ||= []
            args[:options] ||= {}
            users = if users.is_a?(Array)
              users.collect {|user| instantiate(user)}
            else
              instantiate(user)
            end
            users
          end
        end
      end
    end
  end
end
