require_relative "page"

module Async
  module Firefly
    class NestedPage < Page
      def collection = raise NotImplementedError

      def member_path(record) = "../../../" + self.collection + "/" + self.identifier(record, :id)
    end

    class NestedAccountPage < NestedPage
      def member_class = Account

      def collection = "accounts"
    end

    class NestedTransactionPage < NestedPage
      def member_class = Transaction

      def collection = "transactions"
    end

    class NestedAttachmentPage < NestedPage
      def member_class = Attachment

      def collection = "attachments"
    end

    class NestedPiggyBankPage < NestedPage
      def member_class = PiggyBank

      def collection = "piggy-banks"
    end

    class NestedBillPage < NestedPage
      def member_class = Bill

      def collection = "bills"
    end

    class NestedRulePage < NestedPage
      def member_class = Rule

      def collection = "rules"
    end

    class NestedRecurrencePage < NestedPage
      def member_class = Recurrence

      def collection = "recurrences"
    end

    class NestedAvailableBudgetPage < NestedPage
      def member_class = AvailableBudget

      def collection = "available-budgets"
    end

    class NestedExchangeRatePage < NestedPage
      def member_class = CurrencyExchangeRate

      def collection = "exchange-rates"
    end

    class NestedBudgetLimitPage < NestedPage
      def member_class = BudgetLimit

      def collection = "budget-limits"

      def member_path(record)
        "../../../budgets/" + self.identifier(record, :attributes, :budget_id) + "/limits/" + self.identifier(record, :id)
      end
    end
  end
end
