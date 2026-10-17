require_relative "page"

module Async
  module Firefly
    module Data
      def bulk_update_transactions(query)
        self.discard(self.with(path: "v1/data/bulk/transactions", parameters: {query: query}), nil, method: :post)
      end

      def destroy!(objects, unused: nil)
        self.discard(self.with(path: "v1/data/destroy", parameters: {objects: objects, unused: unused}.compact))
      end

      def purge! = self.discard(self.with(path: "v1/data/purge"))

      def export_accounts(**parameters) = self.fetch(Download, self.with(path: "v1/data/export/accounts", parameters: parameters))

      def export_bills(**parameters) = self.fetch(Download, self.with(path: "v1/data/export/bills", parameters: parameters))

      def export_subscriptions(**parameters) = self.fetch(Download, self.with(path: "v1/data/export/subscriptions", parameters: parameters))

      def export_budgets(**parameters) = self.fetch(Download, self.with(path: "v1/data/export/budgets", parameters: parameters))

      def export_categories(**parameters) = self.fetch(Download, self.with(path: "v1/data/export/categories", parameters: parameters))

      def export_piggy_banks(**parameters) = self.fetch(Download, self.with(path: "v1/data/export/piggy-banks", parameters: parameters))

      def export_recurring(**parameters) = self.fetch(Download, self.with(path: "v1/data/export/recurring", parameters: parameters))

      def export_rules(**parameters) = self.fetch(Download, self.with(path: "v1/data/export/rules", parameters: parameters))

      def export_tags(**parameters) = self.fetch(Download, self.with(path: "v1/data/export/tags", parameters: parameters))

      def export_transactions(**parameters) = self.fetch(Download, self.with(path: "v1/data/export/transactions", parameters: parameters))
    end
  end
end
