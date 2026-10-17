require "sus/fixtures/async/reactor_context"

require "async/firefly/openapi"
require "async/firefly/environment"
require "async/firefly/client"

module Async
  module Firefly
    LiveContext = Sus::Shared("a live firefly") do
      include Sus::Fixtures::Async::ReactorContext

      let(:url) {Environment["FIREFLY_URL"]}

      let(:token) {Environment["FIREFLY_TOKEN"]}

      let(:firefly) do
        unless url && token
          skip "set FIREFLY_URL and FIREFLY_TOKEN: eval \"$(bin/firefly-bootstrap)\""
        end

        Client.open(url).authenticated(token)
      end

      after do
        @firefly&.close
      end

      def unique(prefix)
        prefix + "-" + Process.pid.to_s + "-" + Process.clock_gettime(Process::CLOCK_MONOTONIC).to_s
      end
    end
  end
end
