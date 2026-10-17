require_relative "page"

module Async
  module Firefly
    class Attachment < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def attachable_type = self.attributes[:attachable_type]

      def attachable_id = self.attributes[:attachable_id]

      def hash_attribute = self.attributes[:hash]

      def filename = self.attributes[:filename]

      def download_url = self.attributes[:download_url]

      def upload_url = self.attributes[:upload_url]

      def title = self.attributes[:title]

      def notes = self.attributes[:notes]

      def mime = self.attributes[:mime]

      def size = self.attributes[:size]

      def update(payload) = self.submit(Attachment, @resource, payload, method: :put)

      def delete = self.discard(@resource)

      def download = self.fetch(Download, @resource.with(path: "download"))

      def upload_file(bytes, content_type: Content::OCTET_STREAM)
        self.upload(Attachment, @resource.with(path: "upload", headers: {"content-type" => content_type}), bytes)
      end
    end

    class AttachmentPage < Page
      MEMBER = Attachment
    end

    module Attachments
      def attachments(**parameters) = Collection.for(self, "v1/attachments", AttachmentPage, **parameters)

      def attachment(id) = Attachment.new(self.with(path: "v1/attachments/" + Firefly.escape(id)))

      def create_attachment(payload) = self.submit(Attachment, self.with(path: "v1/attachments"), payload, identify: true)
    end
  end
end
