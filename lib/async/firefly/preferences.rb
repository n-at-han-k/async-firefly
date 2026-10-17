require_relative "page"

module Async
  module Firefly
    class Preference < Representation
      def id
        case self.value
        in {data: {id: String | Integer => id}}
          id
        else
          nil
        end
      end

      def type
        case self.value
        in {data: {type: String => type}}
          type
        else
          nil
        end
      end

      def attributes
        case self.value
        in {data: {attributes: Hash => attributes}}
          attributes
        else
          {}
        end
      end

      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def name = self.attributes[:name]

      def data = self.attributes[:data]

      def update(payload) = self.submit(Preference, @resource, payload, method: :put)
    end

    class PreferencePage < Page
      MEMBER = Preference

      def member_path(record) = self.identifier(record, :attributes, :name)
    end

    module Preferences
      def preferences(**parameters) = Collection.for(self, "v1/preferences", PreferencePage, **parameters)

      def preference(name) = Preference.new(self.with(path: "v1/preferences/" + Firefly.escape(name)))

      def create_preference(payload) = self.submit(Preference, self.with(path: "v1/preferences"), payload, identify: :name)
    end
  end
end
