require_relative "page"

module Async
  module Firefly
    class ChartDataPoint < Representation
      def key = self.value[:key]
    end

    class ChartDataSet < Representation
      def label = self.value[:label]

      def currency_id = self.value[:currency_id]

      def currency_name = self.value[:currency_name]

      def currency_code = self.value[:currency_code]

      def currency_symbol = self.value[:currency_symbol]

      def currency_decimal_places = self.value[:currency_decimal_places]

      def primary_currency_id = self.value[:primary_currency_id]

      def primary_currency_name = self.value[:primary_currency_name]

      def primary_currency_code = self.value[:primary_currency_code]

      def primary_currency_symbol = self.value[:primary_currency_symbol]

      def primary_currency_decimal_places = self.value[:primary_currency_decimal_places]

      def date = self.value[:date]

      def start_date = self.value[:start_date]

      def end_date = self.value[:end_date]

      def type = self.value[:type]

      def period = self.value[:period]

      def yAxisID = self.value[:yAxisID]

      def entries = self.value[:entries]

      def pc_entries = self.value[:pc_entries]
    end

    class ChartLine < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(ChartDataSet.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    module Charts
      def account_overview_chart(**parameters) = self.fetch(ChartLine, self.with(path: "v1/chart/account/overview", parameters: parameters))

      def balance_chart(**parameters) = self.fetch(ChartLine, self.with(path: "v1/chart/balance/balance", parameters: parameters))

      def budget_overview_chart(**parameters) = self.fetch(ChartLine, self.with(path: "v1/chart/budget/overview", parameters: parameters))

      def budget_overview_with_limits_chart(**parameters) = self.fetch(ChartLine, self.with(path: "v1/chart/budget/overview-with-limits", parameters: parameters))

      def category_overview_chart(**parameters) = self.fetch(ChartLine, self.with(path: "v1/chart/category/overview", parameters: parameters))
    end
  end
end
