require_relative "page"

module Async
  module Firefly
    class CurrencyExchangeRate < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def from_currency_id = self.attributes[:from_currency_id]

      def from_currency_name = self.attributes[:from_currency_name]

      def from_currency_code = self.attributes[:from_currency_code]

      def from_currency_symbol = self.attributes[:from_currency_symbol]

      def from_currency_decimal_places = self.attributes[:from_currency_decimal_places]

      def to_currency_id = self.attributes[:to_currency_id]

      def to_currency_name = self.attributes[:to_currency_name]

      def to_currency_code = self.attributes[:to_currency_code]

      def to_currency_symbol = self.attributes[:to_currency_symbol]

      def to_currency_decimal_places = self.attributes[:to_currency_decimal_places]

      def rate = self.attributes[:rate]

      def date = self.attributes[:date]

      def update(payload) = self.submit(CurrencyExchangeRate, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class CurrencyExchangeRatePage < Page
      MEMBER = CurrencyExchangeRate
    end

    class ExchangeRatePairPage < Page
      MEMBER = CurrencyExchangeRate

      def member_path(record) = "../../../exchange-rates/" + self.identifier(record, :id)
    end

    class ExchangeRateDatedPage < Page
      MEMBER = CurrencyExchangeRate

      def member_path(record) = "../../../../exchange-rates/" + self.identifier(record, :id)
    end

    module ExchangeRates
      def exchange_rates(**parameters) = Collection.for(self, "v1/exchange-rates", CurrencyExchangeRatePage, **parameters)

      def exchange_rate(id) = CurrencyExchangeRate.new(self.with(path: "v1/exchange-rates/" + Firefly.escape(id)))

      def create_exchange_rate(payload) = self.submit(CurrencyExchangeRate, self.with(path: "v1/exchange-rates"), payload, identify: true)

      def exchange_rates_between(from, to, **parameters) = Collection.for(self, "v1/exchange-rates/" + Firefly.escape(from) + "/" + Firefly.escape(to), ExchangeRatePairPage, **parameters)

      def delete_exchange_rates_between(from, to) = self.discard(self.with(path: "v1/exchange-rates/" + Firefly.escape(from) + "/" + Firefly.escape(to)))

      def exchange_rates_on(from, to, date, **parameters) = Collection.for(self, "v1/exchange-rates/" + Firefly.escape(from) + "/" + Firefly.escape(to) + "/" + Firefly.escape(date), ExchangeRateDatedPage, **parameters)

      def update_exchange_rate_on(from, to, date, payload) = self.submit(CurrencyExchangeRate, self.with(path: "v1/exchange-rates/" + Firefly.escape(from) + "/" + Firefly.escape(to) + "/" + Firefly.escape(date)), payload, method: :put)

      def delete_exchange_rate_on(from, to, date) = self.discard(self.with(path: "v1/exchange-rates/" + Firefly.escape(from) + "/" + Firefly.escape(to) + "/" + Firefly.escape(date)))

      def create_exchange_rates_by_date(date, payload) = self.submit(CurrencyExchangeRatePage, self.with(path: "v1/exchange-rates/by-date/" + Firefly.escape(date)), payload, identify: nil)

      def create_exchange_rates_by_pair(from, to, payload) = self.submit(CurrencyExchangeRatePage, self.with(path: "v1/exchange-rates/by-currencies/" + Firefly.escape(from) + "/" + Firefly.escape(to)), payload, identify: nil)
    end
  end
end
