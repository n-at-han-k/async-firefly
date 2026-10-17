require_relative "page"

module Async
  module Firefly
    class Category < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def name = self.attributes[:name]

      def color = self.attributes[:color]

      def last_activity = self.attributes[:last_activity]

      def notes = self.attributes[:notes]

      def object_has_currency_setting = self.attributes[:object_has_currency_setting]

      def primary_currency_id = self.attributes[:primary_currency_id]

      def primary_currency_name = self.attributes[:primary_currency_name]

      def primary_currency_code = self.attributes[:primary_currency_code]

      def primary_currency_symbol = self.attributes[:primary_currency_symbol]

      def primary_currency_decimal_places = self.attributes[:primary_currency_decimal_places]

      def spent = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:spent])

      def pc_spent = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:pc_spent])

      def earned = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:earned])

      def pc_earned = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:pc_earned])

      def transferred = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:transferred])

      def pc_transferred = self.nested_list(ArrayEntryWithCurrencyAndSum, self.attributes[:pc_transferred])

      def transactions(**parameters) = Collection.for(@resource, "transactions", NestedTransactionPage, **parameters)

      def attachments(**parameters) = Collection.for(@resource, "attachments", NestedAttachmentPage, **parameters)

      def update(payload) = self.submit(Category, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class CategoryPage < Page
      MEMBER = Category
    end

    module Categories
      def categories(**parameters) = Collection.for(self, "v1/categories", CategoryPage, **parameters)

      def category(id) = Category.new(self.with(path: "v1/categories/" + Firefly.escape(id)))

      def create_category(payload) = self.submit(Category, self.with(path: "v1/categories"), payload, identify: true)
    end
  end
end
