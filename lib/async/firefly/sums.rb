require_relative "representation"

module Async
  module Firefly
    class ArrayEntryWithCurrencyAndSum < Representation
      def currency_id = self.value[:currency_id]

      def currency_code = self.value[:currency_code]

      def currency_symbol = self.value[:currency_symbol]

      def currency_decimal_places = self.value[:currency_decimal_places]

      def sum = self.value[:sum]
    end
  end
end
