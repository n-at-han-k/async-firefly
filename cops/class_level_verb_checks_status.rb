require "rubocop"

require_relative "support/prism_source"

module RuboCop
  module Cop
    module AsyncFirefly
      class ClassLevelVerbChecksStatus < Base
        include PrismSource

        MSG = "`%<receiver>s.%<name>s` does not check the status it answered with: pass a block that raises, or go through `submit`, `discard` or `fetch`."

        VERBS = ["get", "post", "put", "patch", "delete"].freeze

        CHECK = "response.success?"

        def on_new_investigation
          self.prism_each(::Prism::CallNode).each do |node|
            self.check(node)
          end
        end

        private

        def check(node)
          if self.class_level_verb?(node) && !self.checks_status?(node)
            add_offense(
              self.prism_node_range(node),
              message: format(MSG, receiver: node.receiver.slice, name: node.name),
            )
          end
        end

        def class_level_verb?(node)
          VERBS.include?(node.name.to_s) && node.receiver.is_a?(::Prism::ConstantReadNode)
        end

        def checks_status?(node)
          node.block&.slice.to_s.include?(CHECK)
        end
      end
    end
  end
end
