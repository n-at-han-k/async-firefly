require "sus/fixtures/async/http/server_context"
require "protocol/url"

require "async/firefly/openapi"
require "async/firefly/client"

module Async
  module Firefly
    TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.test"

    ServerContext = Sus::Shared("a firefly server") do
      include Sus::Fixtures::Async::HTTP::ServerContext

      let(:requests) {[]}

      let(:responses) {{}}

      let(:middleware) do
        recorded = requests
        canned = responses

        ::Protocol::HTTP::Middleware.for do |request|
          path, query = request.path.split("?", 2)

          recorded << {
            method: request.method,
            path: path,
            route: OpenAPI.route_for(request.method, path),
            query: query && ::Protocol::URL::Encoding.decode(query, symbolize_keys: true),
            headers: request.headers.to_h,
            payload: request.body&.join,
          }

          status, body, extra = canned.fetch([request.method, path]) do
            [404, {message: "no such route: " + path}, {}]
          end

          ::Protocol::HTTP::Response[status,
            {"content-type" => "application/vnd.api+json"}.merge(extra || {}),
            [::JSON.dump(body)]]
        end
      end

      let(:firefly) {Client.open(bound_url.to_s + OpenAPI.prefix + "/").authenticated(TOKEN)}

      def respond(method, path, status: 200, body: {}, headers: {})
        unless OpenAPI.documented?(method, path)
          raise ArgumentError, "no " + method + " " + path + " in OpenAPI " + OpenAPI.version
        end

        responses[[method, path]] = [status, body, headers]
      end

      def undocumented_requests
        requests.reject{|request| request[:route]}
      end

      after do
        @firefly&.close
      end
    end
  end
end
