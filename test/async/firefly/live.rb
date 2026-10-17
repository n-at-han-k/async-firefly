require "async/firefly/live_context"

describe Async::Firefly::Client do
  include_context Async::Firefly::LiveContext

  with "the instance itself" do
    it "reports the version the vendored document describes" do
      expect(firefly.about.version).to be == Async::Firefly::OpenAPI.version.delete_prefix("v")
    end

    it "names the user the token belongs to" do
      expect(firefly.current_user.email).not.to be_nil
    end
  end

  with "an account" do
    it "creates, reads, updates and deletes one" do
      name = self.unique("account")

      created = firefly.create_account({name: name, type: "asset", account_role: "defaultAsset", currency_code: "EUR"})

      expect(created.id).to be_a(String)
      expect(created.name).to be == name

      read = Async::Firefly::Account.new(created.resource)

      expect(read.name).to be == name
      expect(read.type).to be == "asset"
      expect(read.current_balance).not.to be_nil

      renamed = read.update({name: name + "-renamed", type: "asset"})

      expect(renamed.name).to be == name + "-renamed"

      expect(firefly.account(created.id).delete).to be == true

      status = nil

      begin
        firefly.account(created.id).name
      rescue Async::REST::ResponseError => error
        status = error.response.status
      end

      expect(status).to be == 404
    end

    it "lists one page at a time, and identifies each member on its own" do
      names = [self.unique("page-a"), self.unique("page-b"), self.unique("page-c")]

      created = names.map do |name|
        firefly.create_account({name: name, type: "asset", account_role: "defaultAsset", currency_code: "EUR"})
      end

      begin
        pages = firefly.accounts.each_page(limit: 2).to_a

        expect(pages.size).to be >= 2

        pages.each do |page|
          expect(page.records.size).to be <= 2
          expect(page.metadata["content-type"]).not.to be_nil
        end

        listed = firefly.accounts.map(&:name)

        names.each do |name|
          expect(listed).to be(:include?, name)
        end

        member = firefly.accounts.find{|account| account.name == names.first}

        expect(member.resource.reference.to_s).to be(:end_with?, "/v1/accounts/" + member.id)
        expect(Async::Firefly::Account.new(member.resource).name).to be == names.first
      ensure
        created.each{|account| firefly.account(account.id).delete}
      end
    end
  end

  with "a transaction" do
    it "creates one between two accounts and reads it back" do
      source = firefly.create_account({name: self.unique("source"), type: "asset", account_role: "defaultAsset", currency_code: "EUR"})
      destination = firefly.create_account({name: self.unique("destination"), type: "expense", currency_code: "EUR"})

      begin
        created = firefly.create_transaction({
          transactions: [{
            type: "withdrawal",
            date: Time.now.utc.strftime("%Y-%m-%d"),
            amount: "12.50",
            description: "Coffee",
            source_id: source.id,
            destination_id: destination.id,
          }],
        })

        expect(created.id).to be_a(String)

        split = created.transactions.first

        expect(split.description).to be == "Coffee"
        expect(split.amount.to_f).to be == 12.5
        expect(split.type).to be == "withdrawal"

        read = firefly.transaction(created.id)

        expect(read.transactions.first.description).to be == "Coffee"

        expect(firefly.transaction(created.id).delete).to be == true
      ensure
        firefly.account(source.id).delete
        firefly.account(destination.id).delete
      end
    end
  end

  with "a tag" do
    it "creates one addressed by its name" do
      name = self.unique("tag")

      created = firefly.create_tag({tag: name})

      begin
        expect(created.tag).to be == name
        expect(created.resource.reference.to_s).to be(:end_with?, "/v1/tags/" + name)
        expect(Async::Firefly::Tag.new(created.resource).tag).to be == name
      ensure
        firefly.tag(name).delete
      end
    end
  end

  with "a currency" do
    it "reads one addressed by its code" do
      currency = firefly.currency("EUR")

      expect(currency.code).to be == "EUR"
      expect(currency.decimal_places).to be_a(Integer)
    end
  end

  with "a failure the instance reports" do
    it "carries the validation errors the API answers with" do
      failure = nil

      begin
        firefly.create_account({})
      rescue Async::Firefly::Failure => error
        failure = error
      end

      expect(failure).not.to be_nil
      expect(failure.status).to be == 422
      expect(failure.invalid?).to be == true
      expect(failure.errors).not.to be(:empty?)
    end
  end
end
