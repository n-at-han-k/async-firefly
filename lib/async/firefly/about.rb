require_relative "page"

module Async
  module Firefly
    class SystemInfo < Representation
      def data = self.value[:data] || {}

      def version = self.data[:version]

      def api_version = self.data[:api_version]

      def php_version = self.data[:php_version]

      def os = self.data[:os]

      def driver = self.data[:driver]
    end

    class ReleaseNotes < Representation
      def version = self.value[:version]

      def release_notes = self.value[:release_notes]

      def release_notes_markdown = self.value[:release_notes_markdown]
    end

    class CronResultRow < Representation
      def job_fired = self.value[:job_fired]

      def job_succeeded = self.value[:job_succeeded]

      def job_errored = self.value[:job_errored]

      def message = self.value[:message]

      def user = self.value[:user]
    end

    class CronResult < Representation
      def recurring_transactions = Array(self.value[:recurring_transactions]).map{|row| CronResultRow.new(@resource, value: row, metadata: self.metadata)}

      def auto_budgets = Array(self.value[:auto_budgets]).map{|row| CronResultRow.new(@resource, value: row, metadata: self.metadata)}

      def exchange_rates = Array(self.value[:exchange_rates]).map{|row| CronResultRow.new(@resource, value: row, metadata: self.metadata)}

      def bill_notifications = Array(self.value[:bill_notifications]).map{|row| CronResultRow.new(@resource, value: row, metadata: self.metadata)}

      def webhooks = Array(self.value[:webhooks]).map{|row| CronResultRow.new(@resource, value: row, metadata: self.metadata)}
    end

    class CurrentUser < Representation
      def self.schema = "User"

      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def email = self.attributes[:email]

      def blocked = self.attributes[:blocked]

      def blocked_code = self.attributes[:blocked_code]

      def role = self.attributes[:role]
    end

    module About
      def about = SystemInfo.new(self.with(path: "v1/about"))

      def current_user = CurrentUser.new(self.with(path: "v1/about/user"))

      def release_notes(version) = ReleaseNotes.new(self.with(path: "v1/release-notes/" + Firefly.escape(version)))

      def cron(token, date: nil, force: nil) = CronResult.new(self.with(path: "v1/cron/" + Firefly.escape(token), parameters: {date: date, force: force}.compact))

      def finish_batch = self.discard(self.with(path: "v1/batch/finish"), method: :post)
    end
  end
end
