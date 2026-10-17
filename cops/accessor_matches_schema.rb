require "rubocop"

require_relative "support/document"
require_relative "support/prism_source"

module RuboCop
  module Cop
    module AsyncFirefly
      class AccessorMatchesSchema < Base
        include Document
        include PrismSource

        MSG_UNKNOWN = "`%<schema>s` has no %<kind>s `%<key>s`: this reads a key `%<document>s` does not describe."

        MSG_MISSING = "`%<schema>s` describes %<count>d attribute this class never reads: %<keys>s."

        MSG_MISSING_MANY = "`%<schema>s` describes %<count>d attributes this class never reads: %<keys>s."

        REPRESENTATION = /Representation\z/

        ATTRIBUTE = /self\.attributes\[:([A-Za-z_][A-Za-z0-9_]*)\]/

        RECORD = /self\.data\[:([A-Za-z_][A-Za-z0-9_]*)\]/

        ROOT = /self\.value\[:([A-Za-z_][A-Za-z0-9_]*)\]/

        INHERITED = /super\(\)\[:([A-Za-z_][A-Za-z0-9_]*)\]/

        def on_new_investigation
          self.prism_each(::Prism::ClassNode).each do |node|
            self.check(node)
          end
        end

        private

        def modules
          @modules ||= self.prism_each(::Prism::ModuleNode).to_h do |node|
            [node.constant_path.slice.split("::").last, node]
          end
        end

        def check(node)
          name = node.constant_path.slice.split("::").last

          if self.representation?(node)
            read = self.read_for(name)

            if read
              self.check_read(node, name, read)
            elsif self.schemas.key?(name) && !self.properties_of(name).empty?
              self.check_plain(node, name)
            end
          end
        end

        def representation?(node)
          superclass = node.superclass

          !superclass.nil? && REPRESENTATION.match?(superclass.slice)
        end

        def check_read(node, name, read)
          attributes = self.attributes_properties_of(read).keys
          record = self.properties_of(read).keys

          self.report_unknown(node, name, "attribute", self.keys_matching(node, ATTRIBUTE) - attributes)
          self.report_unknown(node, name, "property", self.keys_matching(node, RECORD) - record)
          self.report_unknown(node, name, "envelope key", self.keys_matching(node, ROOT) - ENVELOPE_KEYS)

          self.report_missing(node, name, attributes - self.keys_matching(node, ATTRIBUTE) - self.keys_matching(node, INHERITED))
        end

        def check_plain(node, name)
          properties = self.properties_of(name).keys

          self.report_unknown(node, name, "property", self.keys_matching(node, ROOT) - properties)
          self.report_missing(node, name, properties - self.keys_matching(node, ROOT) - self.keys_matching(node, INHERITED))
        end

        def report_unknown(node, name, kind, keys)
          keys.sort.each do |key|
            add_offense(
              self.prism_node_range(node.constant_path),
              message: format(MSG_UNKNOWN, schema: name, kind: kind, key: key, document: self.readable),
            )
          end
        end

        def report_missing(node, name, missing)
          unless missing.empty?
            add_offense(self.prism_range(node.class_keyword_loc), message: self.missing_message(name, missing.sort))
          end
        end

        def missing_message(name, missing)
          keys = missing.map{|key| "`" + key + "`"}.join(", ")

          if missing.size == 1
            format(MSG_MISSING, schema: name, count: missing.size, keys: keys)
          else
            format(MSG_MISSING_MANY, schema: name, count: missing.size, keys: keys)
          end
        end

        def keys_matching(node, pattern)
          self.sources_of(node).flat_map{|source| source.scan(pattern)}.flatten.uniq
        end

        def sources_of(node)
          [node.location.slice].concat(self.included_sources(node))
        end

        def included_sources(node)
          self.included_modules_of(node).filter_map do |name|
            self.modules[name]&.location&.slice
          end
        end

        def included_modules_of(node)
          self.prism_statements(node.body).filter_map do |statement|
            if self.include_call?(statement)
              statement.arguments.arguments.first.slice.split("::").last
            end
          end
        end

        def include_call?(statement)
          statement.is_a?(::Prism::CallNode) &&
            statement.name == :include &&
            statement.receiver.nil? &&
            statement.arguments &&
            statement.arguments.arguments.size == 1 &&
            statement.arguments.arguments.first.is_a?(::Prism::ConstantReadNode)
        end
      end
    end
  end
end
