module SaysServicesClient
  module Models
    class Base < Hashie::Mash
      TIME_FIELDS = [:created_at, :updated_at]

      I18n.enforce_available_locales = true

      include SaysServicesClient::Utils::Connection
      extend ActiveModel::Naming
      extend ActiveModel::Translation
      include ActiveModel::Validations
      include ActiveModel::Conversion
      include ActiveRecord::Validations
      include ActiveRecord::Reflection
      include Hashie::Extensions::Coercion

      class << self
        @@last_request = nil

        def last_request
          @@last_request
        end

        def last_request=(request)
          @@last_request = request
        end

        def coerce(obj)
          if obj.is_a?(Array)
            obj.map do |value|
              self.new(value)
            end
          else
            self.new(obj)
          end
        end

        def parse!(response, args={})
          includes = args.try(:fetch, :params, nil).try(:fetch, :include, nil)
          obj = new(JSON.parse(response.body))
          send("include_#{includes}", [obj], args.try(:fetch, :params, {})) if includes
          self::TIME_FIELDS.each do |field|
            obj[field] = Time.parse(obj[field]) if obj[field]
          end
          obj
        end

        def parse_list!(response, args={})
          object_name = self.to_s.demodulize.pluralize.underscore
          includes = args.try(:fetch, :params, nil).try(:fetch, :include, nil)

          parsed = JSON.parse(response.body)
          objs = parsed[object_name].collect do |o|
            obj = new(o)
            self::TIME_FIELDS.each do |field|
              obj[field] = Time.parse(obj[field]) if obj[field]
            end
            obj
          end

          send("include_#{includes}", objs, args.try(:fetch, :params, {})) if includes

          if offset = parsed["offset"]
            Hashie::Mash.new({
              object_name => objs,
              :offset => offset,
              :next_page? => offset > 0
            })
          else
            page     = parsed["page"] || 1
            per_page = parsed["per_page"] || 20
            total    = parsed["total_entries"]

            WillPaginate::Collection.create(page, per_page, total) do |pager|
              pager.replace objs
            end
          end
        end

        def run_request(response_type, path, args={})
          parse_method = response_type == :list ? :parse_list! : :parse!

          conn = establish_connection(path, args)

          if block_given?
            conn.on_complete do |response|
              if response.response_code == 404
                yield nil
              else
                yield self.send(parse_method, response, args)
              end
            end
            SaysServicesClient::Config.hydra.queue(conn)
          else
            response = conn.run
            return nil if response.response_code == 404
            self.send(parse_method, response, args)
          end
        end

        def find(path, args={})
          conn = establish_connection(path, args)

          if block_given?
            conn.on_complete do |response|
              if response.response_code == 404
                yield nil
              else
                yield parse!(response, args)
              end
            end
            SaysServicesClient::Config.hydra.queue(conn)
          else
            response = conn.run
            return nil if response.response_code == 404
            parse!(response, args)
          end
        end

        def all(path, args={})
          conn = establish_connection(path, args)

          if block_given?
            conn.on_complete do |response|
              yield parse_list!(response, args)
            end
            SaysServicesClient::Config.hydra.queue(conn)
          else
            response = conn.run
            parse_list!(response, args)
          end
        end

        def create(attributes={}, options={})
          object = new(attributes)
          object.save(options)
          object
        end
      end

      def new_record?
        !persisted?
      end

      def persisted?
        id.present?
      end

      def save(options={})
        create_or_update(options)
      end

      private
      def create_or_update(options={})
        result = new_record? ? create(options.merge(method: :post)) : update(options.merge(method: :put))
        result != false
      end

      def create(options={})
        if valid?
          create!(options)
        else
          false
        end
      end

      def create!(options={})
        raise NotImplementedError #implement in subclass
      end

      def update(options={})
        if valid?
          update!(options)
        else
          false
        end
      end

      def update!(options={})
        raise NotImplementedError #implement in subclass
      end

      def post!(path, options)
        conn = self.class.send(:establish_connection, path, options)
        response = conn.run

        attrs = JSON.parse(response.body)

        if response.code == 404
          attrs['errors'].each {|e| errors.add :base, e}
          false
        elsif response.code == 500
          raise StandardError.new(JSON.parse(response.body))
        else
          attrs.each_pair {|k, v| self[k] = v}
          !id.blank?
        end
      end
    end
  end
end
