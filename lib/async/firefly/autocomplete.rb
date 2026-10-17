require_relative "page"

module Async
  module Firefly
    class AutocompleteAccount < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def name_with_balance = self.value[:name_with_balance]

      def active = self.value[:active]

      def type = self.value[:type]

      def currency_id = self.value[:currency_id]

      def currency_name = self.value[:currency_name]

      def currency_code = self.value[:currency_code]

      def currency_symbol = self.value[:currency_symbol]

      def currency_decimal_places = self.value[:currency_decimal_places]

      def account_currency_id = self.value[:account_currency_id]

      def account_currency_name = self.value[:account_currency_name]

      def account_currency_code = self.value[:account_currency_code]

      def account_currency_symbol = self.value[:account_currency_symbol]

      def account_currency_decimal_places = self.value[:account_currency_decimal_places]
    end

    class AutocompleteAccounts < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteAccount.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteBill < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def active = self.value[:active]
    end

    class AutocompleteBills < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteBill.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteBudget < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def active = self.value[:active]
    end

    class AutocompleteBudgets < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteBudget.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteCategory < Representation
      def id = self.value[:id]

      def name = self.value[:name]
    end

    class AutocompleteCategories < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteCategory.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteCurrency < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def code = self.value[:code]

      def symbol = self.value[:symbol]

      def decimal_places = self.value[:decimal_places]
    end

    class AutocompleteCurrencies < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteCurrency.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteObjectGroup < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def title = self.value[:title]
    end

    class AutocompleteObjectGroups < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteObjectGroup.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompletePiggyBalance < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def name_with_balance = self.value[:name_with_balance]

      def currency_id = self.value[:currency_id]

      def currency_code = self.value[:currency_code]

      def currency_symbol = self.value[:currency_symbol]

      def currency_decimal_places = self.value[:currency_decimal_places]

      def object_group_id = self.value[:object_group_id]

      def object_group_title = self.value[:object_group_title]
    end

    class AutocompletePiggyBalances < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompletePiggyBalance.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteRecurrence < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def description = self.value[:description]

      def active = self.value[:active]
    end

    class AutocompleteRecurrences < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteRecurrence.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteRule < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def description = self.value[:description]

      def active = self.value[:active]
    end

    class AutocompleteRules < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteRule.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteRuleGroup < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def description = self.value[:description]

      def active = self.value[:active]
    end

    class AutocompleteRuleGroups < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteRuleGroup.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteTag < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def tag = self.value[:tag]
    end

    class AutocompleteTags < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteTag.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteTransaction < Representation
      def id = self.value[:id]

      def transaction_group_id = self.value[:transaction_group_id]

      def name = self.value[:name]

      def description = self.value[:description]
    end

    class AutocompleteTransactions < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteTransaction.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteTransactionType < Representation
      def id = self.value[:id]

      def name = self.value[:name]

      def type = self.value[:type]
    end

    class AutocompleteTransactionTypes < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteTransactionType.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    class AutocompleteTransactionWithMeta < Representation
      def id = self.value[:id]

      def transaction_group_id = self.value[:transaction_group_id]

      def name = self.value[:name]

      def description = self.value[:description]

      def date = self.value[:date]

      def currency_code = self.value[:currency_code]

      def amount = self.value[:amount]
    end

    class AutocompleteTransactionsWithMeta < Representation
      include Enumerable

      def each(&block)
        if block
          self.deconstruct.each{|record| block.call(AutocompleteTransactionWithMeta.new(@resource, value: record, metadata: self.metadata))}
        else
          self.to_enum(:each)
        end
      end
    end

    module Autocomplete
      def autocomplete_accounts(query: nil, limit: nil, date: nil, types: nil)
        parameters = {query: query, limit: limit, date: date}.compact

        if types
          parameters[:types] = Array(types).join(",")
        end

        self.fetch(AutocompleteAccounts, self.with(path: "v1/autocomplete/accounts", parameters: parameters))
      end

      def autocomplete_bills(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteBills, self.with(path: "v1/autocomplete/bills", parameters: parameters))
      end

      def autocomplete_budgets(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteBudgets, self.with(path: "v1/autocomplete/budgets", parameters: parameters))
      end

      def autocomplete_categories(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteCategories, self.with(path: "v1/autocomplete/categories", parameters: parameters))
      end

      def autocomplete_currencies(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteCurrencies, self.with(path: "v1/autocomplete/currencies", parameters: parameters))
      end

      def autocomplete_object_groups(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteObjectGroups, self.with(path: "v1/autocomplete/object-groups", parameters: parameters))
      end

      def autocomplete_piggy_banks(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompletePiggyBalances, self.with(path: "v1/autocomplete/piggy-banks", parameters: parameters))
      end

      def autocomplete_recurrences(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteRecurrences, self.with(path: "v1/autocomplete/recurring", parameters: parameters))
      end

      def autocomplete_rule_groups(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteRuleGroups, self.with(path: "v1/autocomplete/rule-groups", parameters: parameters))
      end

      def autocomplete_rules(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteRules, self.with(path: "v1/autocomplete/rules", parameters: parameters))
      end

      def autocomplete_subscriptions(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteBills, self.with(path: "v1/autocomplete/subscriptions", parameters: parameters))
      end

      def autocomplete_tags(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteTags, self.with(path: "v1/autocomplete/tags", parameters: parameters))
      end

      def autocomplete_transaction_types(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteTransactionTypes, self.with(path: "v1/autocomplete/transaction-types", parameters: parameters))
      end

      def autocomplete_transactions(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteTransactions, self.with(path: "v1/autocomplete/transactions", parameters: parameters))
      end

      def autocomplete_transactions_with_meta(query: nil, limit: nil)
        parameters = {query: query, limit: limit}.compact

        self.fetch(AutocompleteTransactionsWithMeta, self.with(path: "v1/autocomplete/transactions-with-meta", parameters: parameters))
      end
    end
  end
end
