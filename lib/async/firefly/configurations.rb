require_relative "page"

module Async
  module Firefly
    class Configuration < Representation
      def title = self.value[:title]

      def value_attribute = self.value[:value]

      def editable = self.value[:editable]
    end

    module Configurations
      def configurations
        resource = self.with(path: "v1/configuration")

        Configuration.get(resource) do |target, response|
          unless response.success?
            raise Failure.for(response)
          end

          Array(response.read).map{|item| Configuration.new(target, value: item, metadata: response.headers)}
        end
      end

      def configuration(name)
        resource = self.with(path: "v1/configuration/" + Firefly.escape(name))

        Configuration.get(resource) do |target, response|
          unless response.success?
            raise Failure.for(response)
          end

          self.unwrapped_configuration(target, response)
        end
      end

      def set_configuration(name, payload)
        resource = self.with(path: "v1/configuration/" + Firefly.escape(name))

        self.with_retry do
          Configuration.put(resource, payload) do |target, response|
            unless response.success?
              raise Failure.for(response)
            end

            self.unwrapped_configuration(target, response)
          end
        end
      end

      def unwrapped_configuration(target, response)
        case response.read
        in {data: Hash => data}
          Configuration.new(target, value: data, metadata: response.headers)
        else
          Configuration.new(target, value: {}, metadata: response.headers)
        end
      end
    end
  end
end
