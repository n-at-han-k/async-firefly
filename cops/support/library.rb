module RuboCop
  module Cop
    module Library
      SUFFIX = "_attribute"

      def library
        @library ||= self.load_library
      end

      def load_library
        $LOAD_PATH.unshift(::File.expand_path("../../lib", __dir__)).uniq!

        require "async/firefly"

        ::Async::Firefly
      rescue ::LoadError, ::StandardError
        nil
      end

      def reserved_name?(name)
        self.reserved&.include?(name.to_sym) == true
      end

      def reserved
        @reserved ||= self.collect_reserved
      end

      def collect_reserved
        if self.library
          ::Async::REST::Representation.instance_methods | ::Object.instance_methods | ::Enumerable.instance_methods
        else
          nil
        end
      end

      def client_methods
        @client_methods ||= self.collect_client_methods
      end

      def collect_client_methods
        client = self.library&.const_get(:Client, false)

        if client
          (client.instance_methods - ::Async::REST::Resource.instance_methods).to_set
        else
          nil
        end
      end
    end
  end
end
