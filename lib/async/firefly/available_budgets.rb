require_relative "page"

module Async
  module Firefly
    class AvailableBudget < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def object_has_currency_setting = self.attributes[:object_has_currency_setting]

      def currency_id = self.attributes[:currency_id]

      def currency_name = self.attributes[:currency_name]

      def currency_code = self.attributes[:currency_code]

      def currency_symbol = self.attributes[:currency_symbol]

      def currency_decimal_places = self.attributes[:currency_decimal_places]

      def primary_currency_id = self.attributes[:primary_currency_id]

      def primary_currency_name = self.attributes[:primary_currency_name]

      def primary_currency_code = self.attributes[:primary_currency_code]

      def primary_currency_symbol = self.attributes[:primary_currency_symbol]

      def primary_currency_decimal_places = self.attributes[:primary_currency_decimal_places]

      def amount = self.attributes[:amount]

      def pc_amount = self.attributes[:pc_amount]

      def start = self.attributes[:start]

      def end = self.attributes[:end]

      def spent_in_budgets = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:spent_in_budgets])

      def pc_spent_in_budgets = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:pc_spent_in_budgets])

      def spent_outside_budgets = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:spent_outside_budgets])

      def pc_spent_outside_budgets = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:pc_spent_outside_budgets])
    end

    class AvailableBudgetPage < Page
      MEMBER = AvailableBudget
    end

    module AvailableBudgets
      def available_budgets(**parameters) = Collection.for(self, "v1/available-budgets", AvailableBudgetPage, **parameters)

      def available_budget(id) = AvailableBudget.new(self.with(path: "v1/available-budgets/" + Firefly.escape(id)))
    end
  end
end
