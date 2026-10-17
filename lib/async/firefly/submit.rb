require_relative "error"

module Async
  module Firefly
    module Submit
      TOO_MANY_REQUESTS = 429

      MAXIMUM_ATTEMPTS = 4

      MAXIMUM_DELAY = 30.0

      def submit(klass, resource, payload = nil, method: :post, through: nil, identify: nil)
        carrier = through || klass

        self.with_retry do
          carrier.public_send(method, resource, payload) do |target, response|
            unless response.success?
              raise Failure.for(response)
            end

            self.representation_of(klass, target, response, identify)
          end
        end
      end

      def fetch(klass, resource, &block)
        self.with_retry do
          klass.get(resource) do |target, response|
            unless response.success?
              raise Failure.for(response)
            end

            if block
              block.call(target, response)
            else
              klass.new(target, value: response.read, metadata: response.headers)
            end
          end
        end
      end

      def representation_of(klass, resource, response, identify)
        value = response.read

        klass.new(self.identified(resource, identify, value), value: value, metadata: response.headers)
      end

      def identified(resource, identify, value)
        id = self.identifier_of(value, identify)

        if identify.nil? || id.nil?
          resource
        else
          resource.with(path: self.prefix_of(identify) + Firefly.escape(id), parameters: nil, merge: false)
        end
      end

      def identifier_of(value, identify)
        if identify.is_a?(Symbol)
          self.attribute_of(value, identify)
        else
          self.record_identifier_of(value)
        end
      end

      def record_identifier_of(value)
        case value
        in {data: {id: String | Integer => id}}
          id
        else
          nil
        end
      end

      def attribute_of(value, name)
        case value
        in {data: {attributes: Hash => attributes}}
          attributes[name]
        in {data: Hash => data}
          data[name]
        else
          nil
        end
      end

      def prefix_of(identify)
        if identify == true || identify.is_a?(Symbol)
          ""
        else
          identify
        end
      end

      def upload(klass, resource, bytes, method: :post)
        self.submit(klass, resource, bytes, method: method, through: Upload)
      end

      def discard(resource, payload = nil, method: :delete)
        self.with_retry do
          Representation.public_send(method, resource, payload) do |target, response|
            unless response.success?
              raise Failure.for(response)
            end

            true
          end
        end
      end

      def with_retry(attempts: MAXIMUM_ATTEMPTS, &block)
        attempt = 1

        while true
          begin
            break block.call
          rescue Failure => failure
            if attempt >= attempts
              raise
            end

            unless failure.status == TOO_MANY_REQUESTS
              raise
            end

            delay = failure.retry_after.to_f

            if delay <= 0.0 || delay > MAXIMUM_DELAY
              raise
            end

            attempt += 1

            sleep(delay)
          end
        end
      end
    end
  end
end
