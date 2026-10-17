require_relative "page"

module Async
  module Firefly
    class Currency < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def enabled = self.attributes[:enabled]

      def primary = self.attributes[:primary]

      def code = self.attributes[:code]

      def name = self.attributes[:name]

      def symbol = self.attributes[:symbol]

      def decimal_places = self.attributes[:decimal_places]

      def enabled? = self.enabled == true

      def primary? = self.primary == true

      def accounts(**parameters) = Collection.for(@resource, "accounts", NestedAccountPage, **parameters)

      def available_budgets(**parameters) = Collection.for(@resource, "available-budgets", NestedAvailableBudgetPage, **parameters)

      def bills(**parameters) = Collection.for(@resource, "bills", NestedBillPage, **parameters)

      def budget_limits(**parameters) = NestedBudgetLimitPage.new(@resource.with(path: "budget-limits", parameters: parameters))

      def recurrences(**parameters) = Collection.for(@resource, "recurrences", NestedRecurrencePage, **parameters)

      def rules(**parameters) = NestedRulePage.new(@resource.with(path: "rules", parameters: parameters))

      def transactions(**parameters) = Collection.for(@resource, "transactions", NestedTransactionPage, **parameters)

      def exchange_rates(**parameters) = Collection.for(@resource, "cer", NestedExchangeRatePage, **parameters)

      def enable = self.submit(Currency, @resource.with(path: "enable"), method: :post, identify: nil)

      def disable = self.submit(Currency, @resource.with(path: "disable"), method: :post, identify: nil)

      def make_primary = self.submit(Currency, @resource.with(path: "primary"), method: :post, identify: nil)

      def update(payload) = self.submit(Currency, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class CurrencyPage < Page
      MEMBER = Currency

      def member_path(record) = self.identifier(record, :attributes, :code)
    end

    module Currencies
      def currencies(**parameters) = Collection.for(self, "v1/currencies", CurrencyPage, **parameters)

      def currency(code) = Currency.new(self.with(path: "v1/currencies/" + Firefly.escape(code)))

      def create_currency(payload) = self.submit(Currency, self.with(path: "v1/currencies"), payload, identify: :code)

      def primary_currency = Currency.new(self.with(path: "v1/currencies/primary"))

      def default_currency = Currency.new(self.with(path: "v1/currencies/default"))
    end
  end
end
