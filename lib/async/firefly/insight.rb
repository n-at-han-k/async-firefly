require_relative "page"

module Async
  module Firefly
    class InsightGroupEntry < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def difference = self.value[:difference]

      def difference_float = self.value[:difference_float]

      def currency_id = self.value[:currency_id]

      def currency_code = self.value[:currency_code]
    end

    class InsightTotalEntry < Representation
      def difference = self.value[:difference]

      def difference_float = self.value[:difference_float]

      def currency_id = self.value[:currency_id]

      def currency_code = self.value[:currency_code]
    end

    class InsightTransferEntry < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def difference = self.value[:difference]

      def difference_float = self.value[:difference_float]

      def in = self.value[:in]

      def in_float = self.value[:in_float]

      def out = self.value[:out]

      def out_float = self.value[:out_float]

      def currency_id = self.value[:currency_id]

      def currency_code = self.value[:currency_code]
    end

    class InsightGroup < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(InsightGroupEntry.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class InsightTotal < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(InsightTotalEntry.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class InsightTransfer < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(InsightTransferEntry.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    module Insight
      def expense_by_expense_account(start:, end:, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/expense/expense", parameters: {start:, end:, accounts:}.compact))
      end

      def expense_by_asset_account(start:, end:, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/expense/asset", parameters: {start:, end:, accounts:}.compact))
      end

      def income_by_revenue_account(start:, end:, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/income/revenue", parameters: {start:, end:, accounts:}.compact))
      end

      def income_by_asset_account(start:, end:, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/income/asset", parameters: {start:, end:, accounts:}.compact))
      end

      def transfer_by_asset_account(start:, end:, accounts: nil)
        InsightTransfer.new(self.with(path: "v1/insight/transfer/asset", parameters: {start:, end:, accounts:}.compact))
      end

      def expense_by_bill(start:, end:, bills: nil, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/expense/bill", parameters: {start:, end:, bills:, accounts:}.compact))
      end

      def expense_without_bill(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/expense/no-bill", parameters: {start:, end:, accounts:}.compact))
      end

      def expense_by_budget(start:, end:, budgets: nil, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/expense/budget", parameters: {start:, end:, budgets:, accounts:}.compact))
      end

      def expense_without_budget(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/expense/no-budget", parameters: {start:, end:, accounts:}.compact))
      end

      def expense_by_category(start:, end:, categories: nil, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/expense/category", parameters: {start:, end:, categories:, accounts:}.compact))
      end

      def expense_without_category(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/expense/no-category", parameters: {start:, end:, accounts:}.compact))
      end

      def income_by_category(start:, end:, categories: nil, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/income/category", parameters: {start:, end:, categories:, accounts:}.compact))
      end

      def income_without_category(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/income/no-category", parameters: {start:, end:, accounts:}.compact))
      end

      def transfer_by_category(start:, end:, categories: nil, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/transfer/category", parameters: {start:, end:, categories:, accounts:}.compact))
      end

      def transfer_without_category(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/transfer/no-category", parameters: {start:, end:, accounts:}.compact))
      end

      def expense_by_tag(start:, end:, tags: nil, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/expense/tag", parameters: {start:, end:, tags:, accounts:}.compact))
      end

      def expense_without_tag(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/expense/no-tag", parameters: {start:, end:, accounts:}.compact))
      end

      def income_by_tag(start:, end:, tags: nil, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/income/tag", parameters: {start:, end:, tags:, accounts:}.compact))
      end

      def income_without_tag(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/income/no-tag", parameters: {start:, end:, accounts:}.compact))
      end

      def transfer_by_tag(start:, end:, tags: nil, accounts: nil)
        InsightGroup.new(self.with(path: "v1/insight/transfer/tag", parameters: {start:, end:, tags:, accounts:}.compact))
      end

      def transfer_without_tag(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/transfer/no-tag", parameters: {start:, end:, accounts:}.compact))
      end

      def expense_total(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/expense/total", parameters: {start:, end:, accounts:}.compact))
      end

      def income_total(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/income/total", parameters: {start:, end:, accounts:}.compact))
      end

      def transfer_total(start:, end:, accounts: nil)
        InsightTotal.new(self.with(path: "v1/insight/transfer/total", parameters: {start:, end:, accounts:}.compact))
      end
    end
  end
end
