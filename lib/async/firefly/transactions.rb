require_relative "page"

module Async
  module Firefly
    class TransactionSplit < Representation
      def user = self.value[:user]

      def transaction_journal_id = self.value[:transaction_journal_id]

      def type = self.value[:type]

      def date = self.value[:date]

      def order = self.value[:order]

      def object_has_currency_setting = self.value[:object_has_currency_setting]

      def currency_id = self.value[:currency_id]

      def currency_code = self.value[:currency_code]

      def currency_symbol = self.value[:currency_symbol]

      def currency_name = self.value[:currency_name]

      def currency_decimal_places = self.value[:currency_decimal_places]

      def foreign_currency_id = self.value[:foreign_currency_id]

      def foreign_currency_code = self.value[:foreign_currency_code]

      def foreign_currency_symbol = self.value[:foreign_currency_symbol]

      def foreign_currency_decimal_places = self.value[:foreign_currency_decimal_places]

      def primary_currency_id = self.value[:primary_currency_id]

      def primary_currency_code = self.value[:primary_currency_code]

      def primary_currency_symbol = self.value[:primary_currency_symbol]

      def primary_currency_decimal_places = self.value[:primary_currency_decimal_places]

      def amount = self.value[:amount]

      def pc_amount = self.value[:pc_amount]

      def foreign_amount = self.value[:foreign_amount]

      def pc_foreign_amount = self.value[:pc_foreign_amount]

      def source_balance_after = self.value[:source_balance_after]

      def pc_source_balance_after = self.value[:pc_source_balance_after]

      def destination_balance_after = self.value[:destination_balance_after]

      def pc_destination_balance_after = self.value[:pc_destination_balance_after]

      def description = self.value[:description]

      def source_id = self.value[:source_id]

      def source_name = self.value[:source_name]

      def source_iban = self.value[:source_iban]

      def source_type = self.value[:source_type]

      def destination_id = self.value[:destination_id]

      def destination_name = self.value[:destination_name]

      def destination_iban = self.value[:destination_iban]

      def destination_type = self.value[:destination_type]

      def budget_id = self.value[:budget_id]

      def budget_name = self.value[:budget_name]

      def category_id = self.value[:category_id]

      def category_name = self.value[:category_name]

      def bill_id = self.value[:bill_id]

      def bill_name = self.value[:bill_name]

      def subscription_id = self.value[:subscription_id]

      def subscription_name = self.value[:subscription_name]

      def reconciled = self.value[:reconciled]

      def notes = self.value[:notes]

      def tags = self.value[:tags]

      def internal_reference = self.value[:internal_reference]

      def external_id = self.value[:external_id]

      def external_url = self.value[:external_url]

      def original_source = self.value[:original_source]

      def recurrence_id = self.value[:recurrence_id]

      def recurrence_total = self.value[:recurrence_total]

      def recurrence_count = self.value[:recurrence_count]

      def import_hash_v2 = self.value[:import_hash_v2]

      def sepa_cc = self.value[:sepa_cc]

      def sepa_ct_op = self.value[:sepa_ct_op]

      def sepa_ct_id = self.value[:sepa_ct_id]

      def sepa_db = self.value[:sepa_db]

      def sepa_country = self.value[:sepa_country]

      def sepa_ep = self.value[:sepa_ep]

      def sepa_ci = self.value[:sepa_ci]

      def sepa_batch_id = self.value[:sepa_batch_id]

      def interest_date = self.value[:interest_date]

      def book_date = self.value[:book_date]

      def process_date = self.value[:process_date]

      def due_date = self.value[:due_date]

      def payment_date = self.value[:payment_date]

      def invoice_date = self.value[:invoice_date]

      def latitude = self.value[:latitude]

      def longitude = self.value[:longitude]

      def zoom_level = self.value[:zoom_level]

      def has_attachments = self.value[:has_attachments]
    end

    class Transaction < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def user = self.attributes[:user]

      def group_title = self.attributes[:group_title]

      def transactions
        Array(self.attributes[:transactions]).map do |split|
          TransactionSplit.new(@resource, value: split, metadata: self.metadata)
        end
      end

      def update(payload) = self.submit(Transaction, @resource, payload, method: :put)

      def delete = self.discard(@resource)

      def attachments(**parameters) = Collection.for(@resource, "attachments", TransactionAttachmentPage, **parameters)

      def piggy_bank_events(**parameters) = Collection.for(@resource, "piggy-bank-events", TransactionPiggyBankEventPage, **parameters)
    end

    class TransactionJournal < Representation
      def self.schema = "Transaction"

      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def user = self.attributes[:user]

      def group_title = self.attributes[:group_title]

      def transactions
        Array(self.attributes[:transactions]).map do |split|
          TransactionSplit.new(@resource, value: split, metadata: self.metadata)
        end
      end

      def delete = self.discard(@resource)

      def links(**parameters) = Collection.for(@resource, "links", TransactionJournalLinkPage, **parameters)
    end

    class TransactionPage < Page
      MEMBER = Transaction
    end

    class TransactionAttachmentPage < Page
      MEMBER = Attachment

      def member_path(record) = "../../../attachments/" + self.identifier(record, :id)
    end

    class TransactionPiggyBankEventPage < Page
      MEMBER = PiggyBankEvent

      def member_resource(record) = @resource
    end

    class TransactionJournalLinkPage < Page
      MEMBER = TransactionLink

      def member_path(record) = "../../../transaction-links/" + self.identifier(record, :id)
    end

    module Transactions
      def transactions(**parameters) = Collection.for(self, "v1/transactions", TransactionPage, **parameters)

      def transaction(id) = Transaction.new(self.with(path: "v1/transactions/" + Firefly.escape(id)))

      def create_transaction(payload) = self.submit(Transaction, self.with(path: "v1/transactions"), payload, identify: true)

      def transaction_journal(id) = TransactionJournal.new(self.with(path: "v1/transaction-journals/" + Firefly.escape(id)))
    end
  end
end
