require "set"
require "uri"
require "yaml"

module Async
  module Firefly
    module OpenAPI
      DOCUMENT = ENV.fetch("FIREFLY_OPENAPI", ::File.expand_path("../../../data/openapi-v1.yaml", __dir__))

      METHODS = ["get", "post", "put", "patch", "delete", "head", "options"].freeze

      PARAMETER = /\\\{[^}]+\\\}/

      ENVELOPE = /(?:Single|Array)\z/

      GENERATED = /(?:Store|Update|Filter|Property|Response)\z/

      STRUCTURAL = ["Meta", "PageLink", "ObjectLink"].freeze

      SCHEMA_KEY = "$schema"

      def self.document
        @document ||= ::YAML.safe_load(::File.read(DOCUMENT), aliases: true)
      end

      def self.version
        document.dig("info", "version")
      end

      def self.prefix
        @prefix ||= ::URI.parse(document.fetch("servers").first.fetch("url")).path.chomp("/")
      end

      def self.schemas
        @schemas ||= document.fetch("components", {}).fetch("schemas", {})
      end

      def self.schema_for(name)
        found = schemas[name]

        if found && found["type"] == "object" && !properties_of(name).empty?
          found
        end
      end

      def self.properties_of(name)
        schemas.fetch(name, {}).fetch("properties", {}).reject{|key, _| key == SCHEMA_KEY}
      end

      def self.read_for(entity)
        candidate = entity + "Read"

        if schemas.key?(candidate)
          candidate
        end
      end

      def self.attributes_schema_of(read)
        attributes = schemas.fetch(read, {}).dig("properties", "attributes")

        if attributes
          reference = attributes["$ref"] || attributes.dig("allOf", 0, "$ref")

          if reference
            reference.split("/").last
          end
        end
      end

      def self.attributes_properties_of(read)
        schema = attributes_schema_of(read)

        if schema
          properties_of(schema)
        else
          schemas.fetch(read, {}).dig("properties", "attributes", "properties") || {}
        end
      end

      def self.flat?(read)
        !schemas.fetch(read, {}).dig("properties", "attributes")
      end

      def self.record_properties_of(read)
        if self.flat?(read)
          properties_of(read)
        else
          attributes_properties_of(read)
        end
      end

      def self.reference_of(property)
        items = property["items"]

        if property["$ref"]
          self.kind_of(:one, property["$ref"].split("/").last)
        elsif items.is_a?(Hash) && items["$ref"]
          self.kind_of(:many, items["$ref"].split("/").last)
        else
          [nil, nil]
        end
      end

      def self.kind_of(kind, target)
        if self.schema_for(target)
          [kind, target]
        else
          [nil, nil]
        end
      end

      def self.templates
        @templates ||= document.fetch("paths").keys.to_h do |template|
          pattern = ::Regexp.escape(prefix + template).gsub(PARAMETER, "[^/]+")

          [template, ::Regexp.new("\\A" + pattern + "\\z")]
        end
      end

      def self.route_for(method, path)
        path = path.split("?", 2).first

        unless path == "/"
          path = path.chomp("/")
        end

        matching = templates.select do |template, pattern|
          pattern.match?(path) && document.dig("paths", template).key?(method.to_s.downcase)
        end

        literal = matching.keys.find{|template| !template.include?("{")}

        literal || matching.keys.first
      end

      def self.documented?(method, path)
        !route_for(method, path).nil?
      end

      def self.operation(method, path)
        template = route_for(method, path)

        if template
          document.dig("paths", template, method.to_s.downcase)
        end
      end

      def self.security_for(method, path)
        found = operation(method, path)

        if found
          found.fetch("security", document.fetch("security", []))
        end
      end

      def self.routes
        document.fetch("paths").flat_map do |template, operations|
          operations.keys.select{|key| METHODS.include?(key)}.map do |method|
            [method.upcase, prefix + template]
          end
        end
      end

      def self.references_in(node)
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

      def self.answered_schemas
        @answered_schemas ||= Set.new.tap do |reached|
          frontier = []

          document.fetch("paths").each_value do |operations|
            operations.each_value do |operation|
              if operation.is_a?(Hash)
                operation.fetch("responses", {}).each do |status, response|
                  if status.to_s.match?(/\A2\d\d\z/)
                    frontier.concat(references_in(response))
                  end
                end
              end
            end
          end

          until frontier.empty?
            name = frontier.shift

            unless reached.include?(name) || !schemas.key?(name)
              reached << name
              frontier.concat(references_in(schemas.fetch(name)))
            end
          end
        end
      end

      def self.read_schemas
        @read_schemas ||= answered_schemas.select{|name| name.end_with?("Read")}.sort
      end

      def self.covered_attributes
        @covered_attributes ||= read_schemas.filter_map{|read| attributes_schema_of(read)}.to_set
      end

      def self.entities
        @entities ||= (read_schemas.map{|read| read.delete_suffix("Read")} + plain_entities).sort
      end

      def self.plain_entities
        @plain_entities ||= answered_schemas.reject do |name|
          name.end_with?("Read") || ENVELOPE.match?(name) || GENERATED.match?(name) ||
            STRUCTURAL.include?(name) || covered_attributes.include?(name) ||
            schemas.fetch(name, {})["type"] != "object" || properties_of(name).empty?
        end.sort
      end
    end
  end
end
