require_relative "page"

module Async
  module Firefly
    class BasicSummaryEntry < Representation
      def key = self.value[:key]

      def title = self.value[:title]

      def monetary_value = self.value[:monetary_value]

      def currency_id = self.value[:currency_id]

      def currency_code = self.value[:currency_code]

      def currency_symbol = self.value[:currency_symbol]

      def currency_decimal_places = self.value[:currency_decimal_places]

      def no_available_budgets = self.value[:no_available_budgets]

      def value_parsed = self.value[:value_parsed]

      def sub_title = self.value[:sub_title]
    end

    class BasicSummary < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct_keys(nil).each do |_, entry|
            block.call(BasicSummaryEntry.new(@resource, value: entry, metadata: self.metadata))
          end
        else
          self.to_enum(:each)
        end
      end
    end

    module Summary
      def basic_summary(**parameters) = self.fetch(BasicSummary, self.with(path: "v1/summary/basic", parameters: parameters))
    end
  end
end
