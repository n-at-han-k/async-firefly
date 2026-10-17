require "rubocop"

require_relative "support/library"
require_relative "support/prism_source"

module RuboCop
  module Cop
    module AsyncFirefly
      class NameReadOffLibrary < Base
        include Library
        include PrismSource

        MSG = "`Client` defines no `%<name>s`: read the name off the loaded library before writing it down."

        RECEIVERS = ["firefly", "client"].freeze

        def on_new_investigation
          if self.client_methods
            self.prism_each(::Prism::CallNode).each do |node|
              self.check(node)
            end
          end
        end

        private

        def check(node)
          if self.sent_to_a_client?(node) && !self.client_methods.include?(node.name)
            add_offense(self.prism_range(node.message_loc), message: format(MSG, name: node.name))
          end
        end

        def sent_to_a_client?(node)
          node.message_loc && RECEIVERS.include?(node.receiver&.slice) && !self.resource_method?(node.name)
        end

        def resource_method?(name)
          ::Async::REST::Resource.instance_methods.include?(name)
        end
      end
    end
  end
end
