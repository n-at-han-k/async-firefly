require "async/firefly"

require_relative "openapi"

module Async
  module Firefly
    RepresentationContext = Sus::Shared("a representation of its schema") do
      let(:entity) {subject.schema}

      let(:read) {OpenAPI.read_for(entity)}

      let(:properties) do
        if read
          OpenAPI.record_properties_of(read)
        else
          OpenAPI.properties_of(entity)
        end
      end

      let(:flat) {read && OpenAPI.flat?(read)}

      let(:named) {properties}

      def accessor_for(name)
        owner = self.owner_of(name)

        if owner.nil? || owner.to_s.start_with?("Async::Firefly::")
          name.to_s
        else
          name.to_s + "_attribute"
        end
      end

      def owner_of(name)
        subject.instance_method(name).owner
      rescue ::NameError
        nil
      end

      let(:resource) {Client.new(nil, ::Protocol::URL::Reference.parse("/api/v1/example"))}

      let(:sample) {properties.to_h{|name, property| [name.to_sym, sample_of(name, property)]}}

      let(:payload) do
        if flat
          {data: sample}
        elsif read
          {data: {type: "example", id: "1", attributes: sample}}
        else
          sample
        end
      end

      let(:representation) {subject.new(resource, value: payload, metadata: {"content-type" => "application/vnd.api+json"})}

      def sample_of(name, property, nested: false)
        kind, reference = OpenAPI.reference_of(property)

        case kind
        when :one
          nested_sample(reference, nested)
        when :many
          [nested_sample(reference, nested)]
        else
          scalar_of(name, property)
        end
      end

      def nested_sample(reference, nested)
        if nested
          {}
        else
          OpenAPI.properties_of(reference).to_h do |name, property|
            [name.to_sym, sample_of(name, property, nested: true)]
          end
        end
      end

      def scalar_of(name, property)
        case Array(property["type"]).reject{|type| type == "null"}.first
        when "integer"
          7
        when "number"
          1.5
        when "boolean"
          true
        when "array"
          []
        when "object"
          {}
        else
          name.to_s + "-example"
        end
      end

      it "describes a schema the API answers with" do
        if read
          expect(OpenAPI.schemas).to be(:key?, read)
        else
          expect(OpenAPI.schema_for(entity)).not.to be_nil
        end
      end

      it "reads every attribute the schema describes" do
        missing = named.keys.reject{|name| representation.respond_to?(self.accessor_for(name))}

        expect(missing).to be == []
      end

      it "reads each attribute out of the value it arrived in" do
        named.each do |name, property|
          kind, _ = OpenAPI.reference_of(property)

          unless kind
            expect(representation.public_send(self.accessor_for(name))).to be == sample[name.to_sym]
          end
        end
      end

      it "wraps each nested object as the representation the document references" do
        named.each do |name, property|
          kind, reference = OpenAPI.reference_of(property)

          if kind == :one && Firefly.const_defined?(reference.delete_suffix("Read"), false)
            nested = representation.public_send(self.accessor_for(name))

            expect(nested).to be_a(Representation)
          end
        end
      end

      it "reports no value as no value, rather than as something else" do
        empty = subject.new(resource, value: {})

        filled = named.each_key.reject{|name| blank?(empty.public_send(self.accessor_for(name)))}

        expect(filled).to be == []
      end

      def blank?(value)
        case value
        when nil
          true
        when Array, Hash, String
          value.empty?
        else
          false
        end
      end

      it "masks a credential when it is inspected" do
        secrets = named.keys.map(&:to_sym) & Redacted::SECRET

        secrets.each do |name|
          expect(representation.inspect).not.to be(:include?, sample[name].to_s)
        end
      end

      it "names an accessor whose key the library already defines apart from it" do
        collisions = named.keys.select{|name| self.accessor_for(name) != name.to_s}

        expect(collisions.reject{|name| representation.respond_to?(name.to_s + "_attribute")}).to be == []
      end
    end
  end
end
