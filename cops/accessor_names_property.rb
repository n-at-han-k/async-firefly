require "rubocop"

require_relative "support/library"
require_relative "support/prism_source"

module RuboCop
  module Cop
    module AsyncFirefly
      class AccessorNamesProperty < Base
        include Library
        include PrismSource

        MSG = "`%<name>s` reads `%<key>s`: name the accessor after what it reads, or read what it is named after."

        READS = [
          /self\.attributes\[:([A-Za-z_][A-Za-z0-9_]*)\]/,
          /self\.data\[:([A-Za-z_][A-Za-z0-9_]*)\]/,
          /self\.value\[:([A-Za-z_][A-Za-z0-9_]*)\]/,
          /super\(\)\[:([A-Za-z_][A-Za-z0-9_]*)\]/,
        ].freeze

        def on_new_investigation
          self.prism_each(::Prism::DefNode).each do |node|
            self.check(node)
          end
        end

        private

        def check(node)
          keys = self.keys_of(node)

          if self.accessor?(node) && keys.size == 1 && !self.names?(node, keys.first)
            add_offense(self.prism_range(node.name_loc), message: format(MSG, name: node.name, key: keys.first))
          end
        end

        def names?(node, key)
          name = node.name.to_s

          name == key || (self.reserved_name?(key) && name == key + Library::SUFFIX)
        end

        def keys_of(node)
          source = node.location.slice

          READS.flat_map{|pattern| source.scan(pattern)}.flatten.uniq
        end

        def accessor?(node)
          node.parameters.nil? && !node.name.to_s.end_with?("?", "=", "!")
        end
      end
    end
  end
end
