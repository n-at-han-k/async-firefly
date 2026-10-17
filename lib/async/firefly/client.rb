require "async/rest/resource"

require_relative "about"
require_relative "accounts"
require_relative "attachments"
require_relative "autocomplete"
require_relative "available_budgets"
require_relative "bills"
require_relative "budgets"
require_relative "categories"
require_relative "charts"
require_relative "configurations"
require_relative "currencies"
require_relative "data"
require_relative "error"
require_relative "exchange_rates"
require_relative "insight"
require_relative "links"
require_relative "nested"
require_relative "object_groups"
require_relative "page"
require_relative "sums"
require_relative "piggy_banks"
require_relative "preferences"
require_relative "recurrences"
require_relative "rule_groups"
require_relative "rules"
require_relative "search"
require_relative "submit"
require_relative "summary"
require_relative "tags"
require_relative "transactions"
require_relative "user_groups"
require_relative "users"
require_relative "version"
require_relative "webhooks"

module Async
  module Firefly
    class Client < Async::REST::Resource
      ENDPOINT = Async::HTTP::Endpoint.parse(ENV.fetch("FIREFLY_URL", "http://localhost:8080/api/"))

      USER_AGENT = "async-firefly (https://github.com/n-at-han-k/async-firefly, v" + VERSION + ")"

      include Submit

      include About
      include Accounts
      include Attachments
      include Autocomplete
      include AvailableBudgets
      include Bills
      include Budgets
      include Categories
      include Charts
      include Configurations
      include Currencies
      include Data
      include ExchangeRates
      include Insight
      include Links
      include ObjectGroups
      include PiggyBanks
      include Preferences
      include Recurrences
      include RuleGroups
      include Rules
      include Search
      include Summary
      include Tags
      include Transactions
      include UserGroups
      include Users
      include Webhooks

      def initialize(delegate, reference = ::Protocol::URL::Reference.parse, headers = ::Protocol::HTTP::Headers.new)
        super

        unless @headers["user-agent"]
          @headers = @headers.merge("user-agent" => USER_AGENT)
        end
      end

      def authenticated(token)
        self.with(headers: {"authorization" => "Bearer " + token})
      end
    end
  end
end
