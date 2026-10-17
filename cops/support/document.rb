require "set"
require "yaml"

module RuboCop
  module Cop
    module Document
      ENVELOPE = /(?:Single|Array)\z/

      GENERATED = /(?:Store|Update|Filter|Property|Response)\z/

      STRUCTURAL = ["Meta", "PageLink", "ObjectLink"].freeze

      READ = /Read\z/

      SCHEMA_KEY = "$schema"

      ENVELOPE_KEYS = ["data", "meta", "links"].freeze

      DEFAULT_DOCUMENT_PATH = ::File.expand_path("../../data/openapi-v1.yaml", __dir__)

      def document_path
        cop_config.fetch("DocumentPath", DEFAULT_DOCUMENT_PATH)
      end

      def document
        @document ||= ::YAML.safe_load(::File.read(self.document_path), aliases: true)
      end

      def schemas
        @schemas ||= self.document.fetch("components", {}).fetch("schemas", {})
      end

      def properties_of(name)
        self.schemas.fetch(name, {}).fetch("properties", {}).reject{|key, _| key == SCHEMA_KEY}
      end

      def attributes_schema_of(read)
        attributes = self.schemas.fetch(read, {}).dig("properties", "attributes")

        if attributes
          reference = attributes["$ref"] || attributes.dig("allOf", 0, "$ref")

          if reference
            reference.split("/").last
          end
        end
      end

      def attributes_properties_of(read)
        schema = self.attributes_schema_of(read)

        if schema
          self.properties_of(schema)
        else
          self.schemas.fetch(read, {}).dig("properties", "attributes", "properties") || {}
        end
      end

      def answered_schemas
        @answered_schemas ||= Set.new.tap do |reached|
          frontier = self.response_references.to_a

          until frontier.empty?
            name = frontier.shift

            unless reached.include?(name) || !self.schemas.key?(name)
              reached << name
              frontier.concat(self.references_in(self.schemas.fetch(name)))
            end
          end
        end
      end

      def response_references
        [].tap do |found|
          self.document.fetch("paths", {}).each_value do |operations|
            operations.each_value do |operation|
              if operation.is_a?(Hash)
                operation.fetch("responses", {}).each do |status, response|
                  if status.to_s.match?(/\A2\d\d\z/)
                    found.concat(self.references_in(response))
                  end
                end
              end
            end
          end
        end
      end

      def references_in(node)
        [].tap do |found|
          frontier = [node]

          until frontier.empty?
            current = frontier.shift

            if current.is_a?(Hash)
              reference = current["$ref"]

              if reference.is_a?(String)
                found << reference.split("/").last
              end

              frontier.concat(current.values)
            elsif current.is_a?(Array)
              frontier.concat(current)
            end
          end
        end
      end

      def read_schemas
        @read_schemas ||= self.answered_schemas.select{|name| READ.match?(name)}.sort
      end

      def covered_attributes
        @covered_attributes ||= self.read_schemas.filter_map{|read| self.attributes_schema_of(read)}.to_set
      end

      def plain_entities
        @plain_entities ||= self.answered_schemas.reject do |name|
          READ.match?(name) || ENVELOPE.match?(name) || GENERATED.match?(name) ||
            STRUCTURAL.include?(name) || self.covered_attributes.include?(name) ||
            self.schemas.fetch(name, {})["type"] != "object" || self.properties_of(name).empty?
        end.sort
      end

      def entities
        @entities ||= (self.read_schemas.map{|read| read.delete_suffix("Read")} + self.plain_entities).sort
      end

      def read_for(entity)
        candidate = entity + "Read"

        if self.schemas.key?(candidate)
          candidate
        end
      end

      def readable
        self.document_path.delete_prefix(::File.join(Dir.pwd, ""))
      end
    end
  end
end
