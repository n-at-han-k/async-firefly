# async-firefly

```ruby
gem "async-firefly"
```

```ruby
require "async/firefly"

Async::Firefly::Client.open("https://firefly.example.com/api/") do |client|
  firefly = client.authenticated(ENV.fetch("FIREFLY_TOKEN"))

  firefly.about.version
  firefly.about.api_version
  firefly.about.driver
  firefly.current_user.email
end
```

```ruby
Async::Firefly::Client.open do |client|
  firefly = client.authenticated(ENV.fetch("FIREFLY_TOKEN"))
end
```

```ruby
firefly.accounts.map(&:name)
firefly.accounts(type: "asset").count
firefly.accounts(type: "expense").take(5).map(&:current_balance)

firefly.accounts.each_page(limit: 25) do |page|
  page.records.size
  page.current_page
  page.total_pages
  page.total
  page.last?

  page.each{|account| account.name}
end
```

```ruby
account = firefly.create_account({name: "Savings", type: "asset", account_role: "defaultAsset", currency_code: "EUR"})

account.id
account.name
account.current_balance
account.currency_code
account.iban
account.active?
account.asset?

firefly.account(account.id).name
firefly.account(account.id).update({name: "Rainy day", type: "asset"})
firefly.account(account.id).transactions(start: "2026-01-01", end: "2026-12-31").map(&:group_title)
firefly.account(account.id).attachments.map(&:filename)
firefly.account(account.id).piggy_banks.map(&:name)
firefly.account(account.id).delete
```

```ruby
transaction = firefly.create_transaction({
  transactions: [{
    type: "withdrawal",
    date: "2026-10-17",
    amount: "12.50",
    description: "Coffee",
    source_id: account.id,
    destination_name: "Kiosk",
  }],
})

transaction.id
transaction.group_title
transaction.user

split = transaction.transactions.first

split.description
split.amount
split.date
split.type
split.source_name
split.destination_name
split.category_name
split.reconciled

firefly.transactions(start: "2026-01-01", end: "2026-12-31", type: "withdrawal").map{|each| each.transactions.first.amount}
firefly.transaction(transaction.id).update({transactions: [{description: "Coffee and a bun"}]})
firefly.transaction(transaction.id).attachments.map(&:filename)
firefly.transaction(transaction.id).piggy_bank_events.map(&:amount)
firefly.transaction(transaction.id).delete

firefly.transaction_journal(1).links.map(&:link_type_name)
```

```ruby
bill = firefly.create_bill({name: "Rent", amount_min: "800", amount_max: "900", date: "2026-01-01", repeat_freq: "monthly"})

bill.name
bill.repeat_freq
bill.next_expected_match
bill.paid_dates
bill.active?

firefly.bills.map(&:name)
firefly.bill(bill.id).transactions.count
firefly.bill(bill.id).rules.map(&:title)
firefly.bill(bill.id).attachments.map(&:filename)
firefly.bill(bill.id).update({name: "Rent and service charge"})
firefly.bill(bill.id).delete

firefly.subscriptions.map(&:name)
```

```ruby
budget = firefly.create_budget({name: "Groceries", active: true})

budget.name
budget.auto_budget_type
budget.spent.map(&:sum)

limit = budget.create_limit({amount: "400", start: "2026-10-01", end: "2026-10-31"})

limit.amount
limit.start
limit.end
limit.period

budget.limits.map(&:amount)
budget.limit(limit.id).update({amount: "450"})
budget.limit(limit.id).transactions.count
budget.limit(limit.id).delete
budget.transactions.count
budget.attachments.map(&:filename)
firefly.budget(budget.id).delete

firefly.budgets.map(&:name)
firefly.budget_limits(start: "2026-01-01", end: "2026-12-31").map(&:amount)
firefly.transactions_without_budget.count
```

```ruby
category = firefly.create_category({name: "Travel"})

category.name
category.spent.map(&:sum)
category.earned.map(&:sum)
category.last_activity

firefly.categories.map(&:name)
firefly.category(category.id).transactions.count
firefly.category(category.id).attachments.map(&:filename)
firefly.category(category.id).update({name: "Holidays"})
firefly.category(category.id).delete
```

```ruby
tag = firefly.create_tag({tag: "reimbursable"})

tag.tag
tag.date
tag.description

firefly.tags.map(&:tag)
firefly.tag("reimbursable").transactions.count
firefly.tag("reimbursable").attachments.map(&:filename)
firefly.tag("reimbursable").update({tag: "expensed"})
firefly.tag("expensed").delete
```

```ruby
piggy_bank = firefly.create_piggy_bank({name: "New bike", accounts: [{id: account.id}], target_amount: "500"})

piggy_bank.name
piggy_bank.target_amount
piggy_bank.current_amount
piggy_bank.left_to_save
piggy_bank.percentage
piggy_bank.accounts.map(&:account_id)

firefly.piggy_banks.map(&:name)
firefly.piggy_bank(piggy_bank.id).events.map(&:amount)
firefly.piggy_bank(piggy_bank.id).linked_accounts.map(&:name)
firefly.piggy_bank(piggy_bank.id).attachments.map(&:filename)
firefly.piggy_bank(piggy_bank.id).update({name: "New bicycle"})
firefly.piggy_bank(piggy_bank.id).delete
```

```ruby
firefly.object_groups.map(&:title)
firefly.object_group(1).bills.map(&:name)
firefly.object_group(1).piggy_banks.map(&:name)
firefly.object_group(1).update({title: "Household", order: 1})
firefly.object_group(1).delete
```

```ruby
currency = firefly.currency("EUR")

currency.code
currency.name
currency.symbol
currency.decimal_places
currency.enabled?
currency.primary?

firefly.currencies.map(&:code)
firefly.primary_currency.code
firefly.default_currency.code
firefly.create_currency({code: "NOK", name: "Norwegian krone", symbol: "kr", decimal_places: 2})

firefly.currency("NOK").enable
firefly.currency("NOK").make_primary
firefly.currency("NOK").disable
firefly.currency("EUR").accounts.map(&:name)
firefly.currency("EUR").transactions.count
firefly.currency("EUR").exchange_rates.map(&:rate)
firefly.currency("NOK").delete
```

```ruby
rate = firefly.create_exchange_rate({from: "EUR", to: "GBP", date: "2026-10-17", rate: "0.87"})

rate.rate
rate.date
rate.from_currency_code
rate.to_currency_code

firefly.exchange_rates.map(&:rate)
firefly.exchange_rates_between("EUR", "GBP").map(&:date)
firefly.exchange_rates_on("EUR", "GBP", "2026-10-17").map(&:rate)
firefly.exchange_rate(rate.id).update({rate: "0.88"})
firefly.exchange_rate(rate.id).delete
```

```ruby
recurrence = firefly.create_recurrence({
  type: "withdrawal",
  title: "Rent",
  first_date: "2026-11-01",
  repetitions: [{type: "monthly", moment: "1"}],
  transactions: [{amount: "850", description: "Rent", source_id: account.id}],
})

recurrence.title
recurrence.first_date
recurrence.latest_date
recurrence.repeat_until
recurrence.nr_of_repetitions
recurrence.active?
recurrence.repetitions.map(&:type)
recurrence.transactions.map(&:description)

firefly.recurrences.map(&:title)
firefly.recurrence(recurrence.id).transaction_history.count
firefly.recurrence(recurrence.id).fire
firefly.recurrence(recurrence.id).update({title: "Rent and parking"})
firefly.recurrence(recurrence.id).delete
```

```ruby
rule = firefly.create_rule({
  title: "Tag coffee",
  rule_group_id: "1",
  trigger: "store-journal",
  triggers: [{type: "description_contains", value: "coffee"}],
  actions: [{type: "add_tag", value: "coffee"}],
})

rule.title
rule.trigger
rule.active?
rule.strict
rule.triggers.map(&:type)
rule.actions.map(&:value)

firefly.rules.map(&:title)
firefly.validate_rule_expression("description:coffee")
firefly.rule(rule.id).test(start: "2026-01-01", end: "2026-12-31").count
firefly.rule(rule.id).fire
firefly.rule(rule.id).update({title: "Tag all coffee"})
firefly.rule(rule.id).delete

firefly.rule_groups.map(&:title)
firefly.rule_group(1).rules.map(&:title)
firefly.rule_group(1).test.count
firefly.rule_group(1).fire
```

```ruby
webhook = firefly.create_webhook({
  title: "Ledger mirror",
  url: "https://example.com/hook",
  trigger: "STORE_TRANSACTION",
  response: "TRANSACTIONS",
  delivery: "JSON",
})

webhook.title
webhook.url
webhook.triggers
webhook.responses
webhook.deliveries
webhook.active?
webhook.secret

firefly.webhooks.map(&:title)
firefly.webhook(webhook.id).submit_messages
firefly.webhook(webhook.id).trigger_transaction(1)
firefly.webhook(webhook.id).messages.map(&:uuid)

message = firefly.webhook(webhook.id).message(1)

message.sent?
message.errored?
message.attempts.map(&:status_code)
message.attempt(1).delete
message.delete

firefly.webhook(webhook.id).update({active: false})
firefly.webhook(webhook.id).delete
```

```ruby
attachment = firefly.create_attachment({filename: "receipt.pdf", attachable_type: "TransactionJournal", attachable_id: "1"})

attachment.filename
attachment.title
attachment.mime
attachment.size
attachment.download_url

firefly.attachment(attachment.id).upload_file(File.read("receipt.pdf"), content_type: "application/pdf")
firefly.attachment(attachment.id).download.bytes
firefly.attachment(attachment.id).download.media_type
firefly.attachments.map(&:filename)
firefly.attachment(attachment.id).update({title: "Receipt"})
firefly.attachment(attachment.id).delete
```

```ruby
link_type = firefly.create_link_type({name: "Refund", inward: "is refunded by", outward: "refunds"})

link_type.name
link_type.inward
link_type.outward
link_type.editable

link = firefly.create_transaction_link({link_type_id: link_type.id, inward_id: "1", outward_id: "2"})

link.link_type_name
link.inward_id
link.outward_id

firefly.link_types.map(&:name)
firefly.link_type(link_type.id).transactions.count
firefly.transaction_links.map(&:link_type_name)
firefly.transaction_link(link.id).update({notes: "Partial"})
firefly.transaction_link(link.id).delete
firefly.link_type(link_type.id).delete
```

```ruby
firefly.preferences.map(&:name)
firefly.preference("currencyPreference").data
firefly.preference("currencyPreference").update({data: "EUR"})
firefly.create_preference({name: "listPageSize", data: "100"})
```

```ruby
firefly.configurations.map(&:title)
firefly.configuration("configuration.is_demo_site").editable
firefly.configuration("configuration.is_demo_site").value_attribute
firefly.set_configuration("configuration.single_user_mode", {value: true})
```

```ruby
firefly.users.map(&:email)
firefly.user(1).role
firefly.user(1).blocked
firefly.create_user({email: "new@example.com", blocked: false})
firefly.user(1).update({email: "renamed@example.com"})
firefly.user(1).delete

firefly.user_groups.map(&:title)
firefly.user_group(1).members.map(&:user_email)
firefly.user_group(1).in_use
firefly.user_group(1).update({title: "Household"})
```

```ruby
firefly.autocomplete_accounts(query: "sav", limit: 10).map(&:name_with_balance)
firefly.autocomplete_bills(query: "rent").map(&:name)
firefly.autocomplete_categories(query: "tra").map(&:name)
firefly.autocomplete_tags(query: "reim").map(&:tag)
firefly.autocomplete_transactions(query: "coffee").map(&:description)
firefly.autocomplete_transaction_types(query: "with").map(&:name)
```

```ruby
firefly.expense_by_category(start: "2026-01-01", end: "2026-12-31").map{|entry| [entry.name, entry.difference_float]}
firefly.expense_by_budget(start: "2026-01-01", end: "2026-12-31").map(&:difference)
firefly.expense_total(start: "2026-01-01", end: "2026-12-31").map(&:difference_float)
firefly.expense_without_category(start: "2026-01-01", end: "2026-12-31").map(&:currency_code)
firefly.income_by_revenue_account(start: "2026-01-01", end: "2026-12-31").map(&:name)
firefly.income_total(start: "2026-01-01", end: "2026-12-31").map(&:difference)
firefly.transfer_by_asset_account(start: "2026-01-01", end: "2026-12-31").map(&:difference_float)
```

```ruby
firefly.balance_chart(start: "2026-01-01", end: "2026-12-31").map(&:label)
firefly.account_overview_chart(start: "2026-01-01", end: "2026-12-31").map{|set| [set.label, set.entries]}
firefly.category_overview_chart(start: "2026-01-01", end: "2026-12-31").map(&:currency_code)
firefly.budget_overview_chart(start: "2026-01-01", end: "2026-12-31").map(&:period)
```

```ruby
firefly.basic_summary(start: "2026-01-01", end: "2026-12-31").map{|entry| [entry.key, entry.monetary_value]}
firefly.basic_summary(start: "2026-01-01", end: "2026-12-31").map(&:value_parsed)
```

```ruby
firefly.export_transactions(start: "2026-01-01", end: "2026-12-31").bytes
firefly.export_accounts.media_type
firefly.export_budgets.bytes
firefly.bulk_update_transactions({where: {description: "coffee"}, update: {category_id: "7"}})
```

```ruby
firefly.search_accounts(query: "savings", field: "name").map(&:name)
firefly.search_transactions(query: "amount_gt:100").map{|each| each.transactions.first.amount}
firefly.count_transactions(description: "coffee")
```

```ruby
case firefly.account(1)
in {data: {id: String => id, attributes: {name: String => name}}}
  [id, name]
end

case firefly.transaction(1)
in {data: {attributes: {transactions: [{description: String => description}, *]}}}
  description
end

firefly.basic_summary(start: "2026-01-01", end: "2026-12-31").deconstruct_keys(nil).keys
```

```ruby
begin
  firefly.create_account({})
rescue Async::Firefly::Failure => error
  error.status
  error.detail
  error.exception_class
  error.errors
  error.invalid?
  error.retry_after
end

begin
  firefly.account(404).name
rescue Async::REST::ResponseError => error
  error.response.status
rescue ::JSON::ParserError => error
  error.message
end
```

```ruby
account = firefly.account(1)

account.current_balance
account = firefly.account(1) unless account.cacheable?
account.current_balance
```

```ruby
webhook = firefly.webhook(1)

webhook.inspect
webhook.value[:data][:attributes][:secret]
```

```ruby
Async::Firefly::Client.open do |client|
  firefly = client.authenticated(ENV.fetch("FIREFLY_TOKEN"))

  balances = firefly.accounts(type: "asset").map do |account|
    Async do
      firefly.account(account.id).current_balance
    end
  end

  balances.map(&:wait)
end
```
