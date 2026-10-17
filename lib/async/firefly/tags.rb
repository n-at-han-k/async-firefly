require_relative "page"

module Async
  module Firefly
    class Tag < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def tag = self.attributes[:tag]

      def date = self.attributes[:date]

      def description = self.attributes[:description]

      def latitude = self.attributes[:latitude]

      def longitude = self.attributes[:longitude]

      def zoom_level = self.attributes[:zoom_level]

      def attachments(**parameters) = Collection.for(@resource, "attachments", TagAttachmentPage, **parameters)

      def transactions(**parameters) = Collection.for(@resource, "transactions", TagTransactionPage, **parameters)

      def update(payload) = self.submit(Tag, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class TagPage < Page
      MEMBER = Tag

      def member_path(record) = self.identifier(record, :attributes, :tag)
    end

    class TagAttachmentPage < NestedPage
      def member_class = Attachment

      def collection = "attachments"
    end

    class TagTransactionPage < NestedPage
      def member_class = Transaction

      def collection = "transactions"
    end

    module Tags
      def tags(**parameters) = Collection.for(self, "v1/tags", TagPage, **parameters)

      def tag(name) = Tag.new(self.with(path: "v1/tags/" + Firefly.escape(name)))

      def create_tag(payload) = self.submit(Tag, self.with(path: "v1/tags"), payload, identify: :tag)
    end
  end
end
