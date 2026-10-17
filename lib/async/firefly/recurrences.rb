require_relative "page"

module Async
  module Firefly
    class RecurrenceRepetition < Representation
      def id = self.value[:id]

      def created_at = self.value[:created_at]

      def updated_at = self.value[:updated_at]

      def type = self.value[:type]

      def moment = self.value[:moment]

      def skip = self.value[:skip]

      def weekend = self.value[:weekend]

      def description = self.value[:description]

      def occurrences = self.value[:occurrences]
    end

    class RecurrenceTransaction < Representation
      def id = self.value[:id]

      def description = self.value[:description]

      def object_has_currency_setting = self.value[:object_has_currency_setting]

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

      def amount = self.value[:amount]

      def pc_amount = self.value[:pc_amount]

      def foreign_amount = self.value[:foreign_amount]

      def pc_foreign_amount = self.value[:pc_foreign_amount]

      def foreign_currency_id = self.value[:foreign_currency_id]

      def foreign_currency_name = self.value[:foreign_currency_name]

      def foreign_currency_code = self.value[:foreign_currency_code]

      def foreign_currency_symbol = self.value[:foreign_currency_symbol]

      def foreign_currency_decimal_places = self.value[:foreign_currency_decimal_places]

      def budget_id = self.value[:budget_id]

      def budget_name = self.value[:budget_name]

      def category_id = self.value[:category_id]

      def category_name = self.value[:category_name]

      def source_id = self.value[:source_id]

      def source_name = self.value[:source_name]

      def source_iban = self.value[:source_iban]

      def source_type = self.value[:source_type]

      def destination_id = self.value[:destination_id]

      def destination_name = self.value[:destination_name]

      def destination_iban = self.value[:destination_iban]

      def destination_type = self.value[:destination_type]

      def tags = self.value[:tags]

      def piggy_bank_id = self.value[:piggy_bank_id]

      def piggy_bank_name = self.value[:piggy_bank_name]

      def subscription_id = self.value[:subscription_id]

      def subscription_name = self.value[:subscription_name]
    end

    class Recurrence < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def type = self.attributes[:type]

      def title = self.attributes[:title]

      def description = self.attributes[:description]

      def first_date = self.attributes[:first_date]

      def latest_date = self.attributes[:latest_date]

      def repeat_until = self.attributes[:repeat_until]

      def apply_rules = self.attributes[:apply_rules]

      def active = self.attributes[:active]

      def nr_of_repetitions = self.attributes[:nr_of_repetitions]

      def notes = self.attributes[:notes]

      def repetitions = self.nested_list(RecurrenceRepetition, self.attributes[:repetitions])

      def transactions = self.nested_list(RecurrenceTransaction, self.attributes[:transactions])

      def active? = self.active == true

      def transaction_history(**parameters) = Collection.for(@resource, "transactions", RecurrenceTransactionPage, **parameters)

      def fire(**parameters) = self.submit(RecurrenceTriggerPage, @resource.with(path: "trigger", parameters: parameters), identify: nil)

      def update(payload) = self.submit(Recurrence, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class RecurrencePage < Page
      MEMBER = Recurrence
    end

    class RecurrenceTransactionPage < Page
      def member_class = Transaction

      def member_path(record) = "../../../transactions/" + self.identifier(record, :id)
    end

    class RecurrenceTriggerPage < Page
      def member_class = Transaction

      def member_path(record) = "../../../transactions/" + self.identifier(record, :id)
    end

    module Recurrences
      def recurrences(**parameters) = Collection.for(self, "v1/recurrences", RecurrencePage, **parameters)

      def recurrence(id) = Recurrence.new(self.with(path: "v1/recurrences/" + Firefly.escape(id)))

      def create_recurrence(payload) = self.submit(Recurrence, self.with(path: "v1/recurrences"), payload, identify: true)
    end
  end
end
