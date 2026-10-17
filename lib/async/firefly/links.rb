require_relative "page"

module Async
  module Firefly
    class LinkType < Representation
      def name = self.attributes[:name]

      def inward = self.attributes[:inward]

      def outward = self.attributes[:outward]

      def editable = self.attributes[:editable]

      def transactions(**parameters) = Collection.for(@resource, "transactions", LinkTypeTransactionPage, **parameters)

      def update(payload) = self.submit(LinkType, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class TransactionLink < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def link_type_id = self.attributes[:link_type_id]

      def link_type_name = self.attributes[:link_type_name]

      def inward_id = self.attributes[:inward_id]

      def outward_id = self.attributes[:outward_id]

      def notes = self.attributes[:notes]

      def update(payload) = self.submit(TransactionLink, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class LinkTypePage < Page
      MEMBER = LinkType
    end

    class TransactionLinkPage < Page
      MEMBER = TransactionLink
    end

    class LinkTypeTransactionPage < Page
      def member_class = Transaction

      def member_path(record) = "../../../transactions/" + self.identifier(record, :id)
    end

    module Links
      def link_types(**parameters) = Collection.for(self, "v1/link-types", LinkTypePage, **parameters)

      def link_type(id) = LinkType.new(self.with(path: "v1/link-types/" + Firefly.escape(id)))

      def create_link_type(payload) = self.submit(LinkType, self.with(path: "v1/link-types"), payload, identify: true)

      def transaction_links(**parameters) = Collection.for(self, "v1/transaction-links", TransactionLinkPage, **parameters)

      def transaction_link(id) = TransactionLink.new(self.with(path: "v1/transaction-links/" + Firefly.escape(id)))

      def create_transaction_link(payload) = self.submit(TransactionLink, self.with(path: "v1/transaction-links"), payload, identify: true)
    end
  end
end
