require_relative "page"

module Async
  module Firefly
    class PiggyBankAccount < Representation
      def account_id = self.data[:account_id]

      def name = self.data[:name]

      def current_amount = self.data[:current_amount]

      def pc_current_amount = self.data[:pc_current_amount]
    end

    class PiggyBank < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def name = self.attributes[:name]

      def percentage = self.attributes[:percentage]

      def start_date = self.attributes[:start_date]

      def target_date = self.attributes[:target_date]

      def order = self.attributes[:order]

      def active = self.attributes[:active]

      def notes = self.attributes[:notes]

      def object_group_id = self.attributes[:object_group_id]

      def object_group_order = self.attributes[:object_group_order]

      def object_group_title = self.attributes[:object_group_title]

      def accounts = self.nested_list(PiggyBankAccount, self.attributes[:accounts])

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

      def target_amount = self.attributes[:target_amount]

      def pc_target_amount = self.attributes[:pc_target_amount]

      def current_amount = self.attributes[:current_amount]

      def pc_current_amount = self.attributes[:pc_current_amount]

      def left_to_save = self.attributes[:left_to_save]

      def pc_left_to_save = self.attributes[:pc_left_to_save]

      def save_per_month = self.attributes[:save_per_month]

      def pc_save_per_month = self.attributes[:pc_save_per_month]

      def active? = self.active == true

      def events(**parameters) = Collection.for(@resource, "events", PiggyBankEventPage, **parameters)

      def attachments(**parameters) = Collection.for(@resource, "attachments", NestedAttachmentPage, **parameters)

      def linked_accounts(**parameters) = Collection.for(@resource, "accounts", PiggyBankLinkedAccountPage, **parameters)

      def update(payload) = self.submit(PiggyBank, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class PiggyBankEvent < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def amount = self.attributes[:amount]

      def pc_amount = self.attributes[:pc_amount]

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

      def transaction_journal_id = self.attributes[:transaction_journal_id]

      def transaction_group_id = self.attributes[:transaction_group_id]
    end

    class PiggyBankPage < Page
      MEMBER = PiggyBank
    end

    class PiggyBankEventPage < Page
      MEMBER = PiggyBankEvent

      def member_resource(record) = @resource
    end

    class PiggyBankLinkedAccountPage < NestedPage
      def member_class = Account

      def collection = "accounts"
    end

    module PiggyBanks
      def piggy_banks(**parameters) = Collection.for(self, "v1/piggy-banks", PiggyBankPage, **parameters)

      def piggy_bank(id) = PiggyBank.new(self.with(path: "v1/piggy-banks/" + Firefly.escape(id)))

      def create_piggy_bank(payload) = self.submit(PiggyBank, self.with(path: "v1/piggy-banks"), payload, identify: true)
    end
  end
end
