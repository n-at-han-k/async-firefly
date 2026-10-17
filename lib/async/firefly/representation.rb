require "async/rest/representation"

require_relative "escape"
require_relative "redacted"
require_relative "submit"
require_relative "wrapper"

module Async
  module Firefly
    class Representation < Async::REST::Representation[Wrapper]
      include Redacted
      include Submit

      def self.schema = self.name.to_s.split("::").last

      def data
        case self.value
        in {data: Hash => data}
          data
        in {data: Array}
          {}
        in Hash => value
          value
        else
          {}
        end
      end

      def attributes
        case self.data
        in {attributes: Hash => attributes}
          attributes
        else
          {}
        end
      end

      def id = self.data[:id]

      def type = self.data[:type]

      def deconstruct_keys(keys)
        case self.value
        in Hash => value
          value
        else
          {}
        end
      end

      def deconstruct
        case self.value
        in Array => value
          value
        else
          []
        end
      end

      def cacheable?
        cache_control = self.metadata["cache-control"]

        if cache_control
          !cache_control.no_store?
        else
          true
        end
      end

      def nested(klass, value)
        if value
          klass.new(@resource, value: value, metadata: self.metadata)
        end
      end

      def nested_list(klass, values)
        Array(values).map do |value|
          self.nested(klass, value)
        end
      end
    end

    class Download < Representation
      WRAPPER = Content.new

      def bytes = self.value

      def media_type = self.metadata["content-type"]&.split(";")&.first

      def content_disposition = self.metadata["content-disposition"]

      def size = self.value.to_s.bytesize
    end

    class Upload < Representation
      WRAPPER = Binary.new
    end
  end
end
