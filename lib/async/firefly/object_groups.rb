require_relative "page"

module Async
  module Firefly
    class ObjectGroup < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def title = self.attributes[:title]

      def order = self.attributes[:order]

      def piggy_banks(**parameters) = Collection.for(@resource, "piggy-banks", NestedPiggyBankPage, **parameters)

      def bills(**parameters) = Collection.for(@resource, "bills", NestedBillPage, **parameters)

      def update(payload) = self.submit(ObjectGroup, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class ObjectGroupPage < Page
      MEMBER = ObjectGroup
    end

    module ObjectGroups
      def object_groups(**parameters) = Collection.for(self, "v1/object-groups", ObjectGroupPage, **parameters)

      def object_group(id) = ObjectGroup.new(self.with(path: "v1/object-groups/" + Firefly.escape(id)))
    end
  end
end
