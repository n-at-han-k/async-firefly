require_relative "page"

module Async
  module Firefly
    class Account < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def active = self.attributes[:active]

      def order = self.attributes[:order]

      def name = self.attributes[:name]

      def type = self.attributes[:type]

      def account_role = self.attributes[:account_role]

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

      def current_balance = self.attributes[:current_balance]

      def pc_current_balance = self.attributes[:pc_current_balance]

      def balance_difference = self.attributes[:balance_difference]

      def pc_balance_difference = self.attributes[:pc_balance_difference]

      def opening_balance = self.attributes[:opening_balance]

      def pc_opening_balance = self.attributes[:pc_opening_balance]

      def virtual_balance = self.attributes[:virtual_balance]

      def pc_virtual_balance = self.attributes[:pc_virtual_balance]

      def debt_amount = self.attributes[:debt_amount]

      def pc_debt_amount = self.attributes[:pc_debt_amount]

      def current_balance_date = self.attributes[:current_balance_date]

      def notes = self.attributes[:notes]

      def monthly_payment_date = self.attributes[:monthly_payment_date]

      def credit_card_type = self.attributes[:credit_card_type]

      def account_number = self.attributes[:account_number]

      def iban = self.attributes[:iban]

      def bic = self.attributes[:bic]

      def opening_balance_date = self.attributes[:opening_balance_date]

      def liability_type = self.attributes[:liability_type]

      def liability_direction = self.attributes[:liability_direction]

      def interest = self.attributes[:interest]

      def interest_period = self.attributes[:interest_period]

      def include_net_worth = self.attributes[:include_net_worth]

      def longitude = self.attributes[:longitude]

      def latitude = self.attributes[:latitude]

      def zoom_level = self.attributes[:zoom_level]

      def last_activity = self.attributes[:last_activity]

      def active? = self.active == true

      def asset? = self.type == "asset"

      def transactions(**parameters) = Collection.for(@resource, "transactions", NestedTransactionPage, **parameters)

      def attachments(**parameters) = Collection.for(@resource, "attachments", NestedAttachmentPage, **parameters)

      def piggy_banks(**parameters) = Collection.for(@resource, "piggy-banks", NestedPiggyBankPage, **parameters)

      def update(payload) = self.submit(Account, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class AccountPage < Page
      MEMBER = Account
    end

    module Accounts
      def accounts(**parameters) = Collection.for(self, "v1/accounts", AccountPage, **parameters)

      def account(id) = Account.new(self.with(path: "v1/accounts/" + Firefly.escape(id)))

      def create_account(payload) = self.submit(Account, self.with(path: "v1/accounts"), payload, identify: true)
    end
  end
end
