require "async/rest/wrapper/generic"
require "async/rest/wrapper/json"
require "protocol/http/body/buffered"
require "protocol/http/body/wrapper"

require_relative "error"

module Async
  module Firefly
    class Wrapper < Async::REST::Wrapper::JSON
      VND_API_JSON = "application/vnd.api+json"

      ACCEPT = [VND_API_JSON, Async::REST::Wrapper::JSON::APPLICATION_JSON].join(", ")

      JSON_SUFFIX = "json"

      def initialize(content_type = VND_API_JSON)
        super
      end

      def response_for(resource, request) = resource.call(request)

      def prepare_request(request, payload)
        request.headers["accept"] ||= ACCEPT

        if payload
          request.headers["content-type"] = Async::REST::Wrapper::JSON::APPLICATION_JSON
          request.body = ::Protocol::HTTP::Body::Buffered.new([::JSON.dump(payload)])
        end
      end

      def parser_for(response)
        content_type = response.headers["content-type"]

        if content_type&.include?(JSON_SUFFIX)
          Async::REST::Wrapper::JSON::Parser
        end
      end
    end

    class Content < Async::REST::Wrapper::Generic
      OCTET_STREAM = "application/octet-stream"

      def response_for(resource, request) = resource.call(request)

      def prepare_request(request, payload)
        request.headers["accept"] ||= OCTET_STREAM

        if payload
          request.body = ::Protocol::HTTP::Body::Buffered.new([payload.to_s])
        end
      end
    end

    class Binary < Wrapper
      def prepare_request(request, payload)
        request.headers["accept"] ||= ACCEPT

        if payload
          request.body = ::Protocol::HTTP::Body::Buffered.new([payload.to_s])
        end
      end
    end
  end
end
