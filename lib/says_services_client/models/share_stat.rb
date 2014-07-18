module SaysServicesClient
  class ShareStat < Models::Base
    class << self
      def find_by_user_id(id, options={})
        options.symbolize_keys!
        raise ActiveModel::MissingAttributeError.new("country") if options[:country].blank?
      
        conn = establish_connection("/#{options[:country]}/api/v2/share_stats/#{id}", params: options)
      
        if block_given?
          conn.on_complete do |response|
            yield parse!(response, options)
          end          
          SaysServicesClient::Config.hydra.queue(conn)
        else
          response = conn.run
          parse!(response, options)
        end        
      end
    end
  end
end