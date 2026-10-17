require_relative "page"

module Async
  module Firefly
    class Budget < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def active = self.attributes[:active]

      def name = self.attributes[:name]

      def order = self.attributes[:order]

      def notes = self.attributes[:notes]

      def auto_budget_type = self.attributes[:auto_budget_type]

      def auto_budget_period = self.attributes[:auto_budget_period]

      def object_group_id = self.attributes[:object_group_id]

      def object_group_order = self.attributes[:object_group_order]

      def object_group_title = self.attributes[:object_group_title]

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

      def auto_budget_amount = self.attributes[:auto_budget_amount]

      def pc_auto_budget_amount = self.attributes[:pc_auto_budget_amount]

      def spent = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:spent])

      def pc_spent = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:pc_spent])

      def active? = self.active == true

      def limits(**parameters) = BudgetLimitPage.new(@resource.with(path: "limits", parameters: parameters))

      def limit(id) = BudgetLimit.new(@resource.with(path: "limits/" + Firefly.escape(id)))

      def create_limit(payload) = self.submit(BudgetLimit, @resource.with(path: "limits"), payload, identify: true)

      def transactions(**parameters) = Collection.for(@resource, "transactions", NestedTransactionPage, **parameters)

      def attachments(**parameters) = Collection.for(@resource, "attachments", NestedAttachmentPage, **parameters)

      def update(payload) = self.submit(Budget, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class BudgetPage < Page
      MEMBER = Budget
    end

    class BudgetLimit < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def start = self.attributes[:start]

      def end = self.attributes[:end]

      def budget_id = self.attributes[:budget_id]

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

      def period = self.attributes[:period]

      def spent = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:spent])

      def pc_spent = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:pc_spent])

      def notes = self.attributes[:notes]

      def transactions(**parameters) = Collection.for(@resource, "transactions", BudgetLimitTransactionPage, **parameters)

      def update(payload) = self.submit(BudgetLimit, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class BudgetLimitPage < Page
      MEMBER = BudgetLimit
    end

    class BudgetLimitListPage < Page
      MEMBER = BudgetLimit

      def member_path(record) = "../budgets/" + self.identifier(record, :attributes, :budget_id) + "/limits/" + self.identifier(record, :id)
    end

    class BudgetLimitTransactionPage < Page
      def member_class = Transaction

      def member_path(record) = "../../../../../transactions/" + self.identifier(record, :id)
    end

    class TransactionsWithoutBudgetPage < Page
      def member_class = Transaction

      def member_path(record) = "../../transactions/" + self.identifier(record, :id)
    end

    module Budgets
      def budgets(**parameters) = Collection.for(self, "v1/budgets", BudgetPage, **parameters)

      def budget(id) = Budget.new(self.with(path: "v1/budgets/" + Firefly.escape(id)))

      def create_budget(payload) = self.submit(Budget, self.with(path: "v1/budgets"), payload, identify: true)

      def budget_limits(**parameters) = BudgetLimitListPage.new(self.with(path: "v1/budget-limits", parameters: parameters))

      def transactions_without_budget(**parameters) = Collection.for(self, "v1/budgets/transactions-without-budget", TransactionsWithoutBudgetPage, **parameters)
    end
  end
end
