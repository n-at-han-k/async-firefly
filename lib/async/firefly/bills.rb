require_relative "page"

module Async
  module Firefly
    class Bill < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def name = self.attributes[:name]

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

      def amount_min = self.attributes[:amount_min]

      def pc_amount_min = self.attributes[:pc_amount_min]

      def amount_max = self.attributes[:amount_max]

      def pc_amount_max = self.attributes[:pc_amount_max]

      def amount_avg = self.attributes[:amount_avg]

      def pc_amount_avg = self.attributes[:pc_amount_avg]

      def date = self.attributes[:date]

      def end_date = self.attributes[:end_date]

      def extension_date = self.attributes[:extension_date]

      def repeat_freq = self.attributes[:repeat_freq]

      def skip = self.attributes[:skip]

      def active = self.attributes[:active]

      def order = self.attributes[:order]

      def notes = self.attributes[:notes]

      def object_group_id = self.attributes[:object_group_id]

      def object_group_order = self.attributes[:object_group_order]

      def object_group_title = self.attributes[:object_group_title]

      def paid_dates = self.attributes[:paid_dates]

      def pay_dates = self.attributes[:pay_dates]

      def next_expected_match = self.attributes[:next_expected_match]

      def next_expected_match_diff = self.attributes[:next_expected_match_diff]

      def active? = self.active == true

      def attachments(**parameters) = Collection.for(@resource, "attachments", NestedAttachmentPage, **parameters)

      def rules(**parameters) = NestedRulePage.new(@resource.with(path: "rules", parameters: parameters))

      def transactions(**parameters) = Collection.for(@resource, "transactions", NestedTransactionPage, **parameters)

      def update(payload) = self.submit(Bill, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class BillPage < Page
      MEMBER = Bill
    end

    module Bills
      def bills(**parameters) = Collection.for(self, "v1/bills", BillPage, **parameters)

      def bill(id) = Bill.new(self.with(path: "v1/bills/" + Firefly.escape(id)))

      def create_bill(payload) = self.submit(Bill, self.with(path: "v1/bills"), payload, identify: true)

      def subscriptions(**parameters) = Collection.for(self, "v1/subscriptions", BillPage, **parameters)

      def subscription(id) = Bill.new(self.with(path: "v1/subscriptions/" + Firefly.escape(id)))

      def create_subscription(payload) = self.submit(Bill, self.with(path: "v1/subscriptions"), payload, identify: true)
    end
  end
end
