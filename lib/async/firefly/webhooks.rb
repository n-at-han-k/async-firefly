require_relative "page"

module Async
  module Firefly
    class Webhook < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def active = self.attributes[:active]

      def title = self.attributes[:title]

      def secret = self.attributes[:secret]

      def triggers = self.attributes[:triggers]

      def responses = self.attributes[:responses]

      def deliveries = self.attributes[:deliveries]

      def url = self.attributes[:url]

      def active? = self.active == true

      def messages(**parameters) = WebhookMessagePage.new(@resource.with(path: "messages", parameters: parameters))

      def message(id) = WebhookMessage.new(@resource.with(path: "messages/" + Firefly.escape(id)))

      def submit_messages = self.discard(@resource.with(path: "submit"), method: :post)

      def trigger_transaction(transaction_id) = self.discard(@resource.with(path: "trigger-transaction/" + Firefly.escape(transaction_id)), method: :post)

      def update(payload) = self.submit(Webhook, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class WebhookMessage < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def sent = self.attributes[:sent]

      def errored = self.attributes[:errored]

      def webhook_id = self.attributes[:webhook_id]

      def uuid = self.attributes[:uuid]

      def message = self.attributes[:message]

      def sent? = self.sent == true

      def errored? = self.errored == true

      def attempts(**parameters) = Collection.for(@resource, "attempts", WebhookAttemptPage, **parameters)

      def attempt(id) = WebhookAttempt.new(@resource.with(path: "attempts/" + Firefly.escape(id)))

      def delete = self.discard(@resource)
    end

    class WebhookAttempt < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def webhook_message_id = self.attributes[:webhook_message_id]

      def status_code = self.attributes[:status_code]

      def logs = self.attributes[:logs]

      def response = self.attributes[:response]

      def delete = self.discard(@resource)
    end

    class WebhookPage < Page
      MEMBER = Webhook
    end

    class WebhookMessagePage < Page
      MEMBER = WebhookMessage
    end

    class WebhookAttemptPage < Page
      MEMBER = WebhookAttempt
    end

    module Webhooks
      def webhooks(**parameters) = Collection.for(self, "v1/webhooks", WebhookPage, **parameters)

      def webhook(id) = Webhook.new(self.with(path: "v1/webhooks/" + Firefly.escape(id)))

      def create_webhook(payload) = self.submit(Webhook, self.with(path: "v1/webhooks"), payload, identify: true)
    end
  end
end
