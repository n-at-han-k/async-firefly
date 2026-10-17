require "async/firefly/openapi"

describe Async::Firefly::OpenAPI do
  let(:openapi) {subject}

  let(:pinned) {::File.read(::File.expand_path("../../../docker-compose.yml", __dir__))[%r{image: fireflyiii/core:version-(\S+)}, 1]}

  it "reads the vendored v1 document" do
    expect(openapi.version).to be(:start_with?, "v6.")
    expect(openapi.prefix).to be == "/api"
    expect(openapi.routes).not.to be(:empty?)
  end

  it "describes the release the tests are run against" do
    expect(openapi.version.delete_prefix("v")).to be == pinned
  end

  with "#route_for" do
    it "matches a literal path" do
      expect(openapi.route_for("GET", "/api/v1/accounts")).to be == "/v1/accounts"
    end

    it "matches a templated path" do
      expect(openapi.route_for("GET", "/api/v1/accounts/7/transactions")).to be == "/v1/accounts/{id}/transactions"
    end

    it "ignores the query" do
      expect(openapi.route_for("GET", "/api/v1/accounts?page=2")).to be == "/v1/accounts"
    end

    it "rejects an undocumented path" do
      expect(openapi.route_for("GET", "/api/v1/nope")).to be_nil
    end

    it "rejects a path missing the server prefix" do
      expect(openapi.route_for("GET", "/v1/accounts")).to be_nil
    end
  end

  with "the entities it describes" do
    it "maps a read schema to the representation that answers for it" do
      expect(openapi.read_for("Account")).to be == "AccountRead"
      expect(openapi.attributes_schema_of("AccountRead")).to be == "AccountProperties"
      expect(openapi.attributes_schema_of("TagRead")).to be == "TagModel"
    end

    it "reports the one read schema that carries no attributes at all" do
      expect(openapi.flat?("PiggyBankAccountRead")).to be == true
      expect(openapi.attributes_schema_of("PiggyBankAccountRead")).to be_nil
      expect(openapi.record_properties_of("PiggyBankAccountRead").keys).to be == ["account_id", "name", "current_amount", "pc_current_amount"]
    end

    it "reports an ordinary read schema as carrying attributes" do
      expect(openapi.flat?("AccountRead")).to be == false
      expect(openapi.record_properties_of("AccountRead")).to be == openapi.properties_of("AccountProperties")
    end

    it "treats a reference to a string enum as a scalar" do
      property = openapi.properties_of("AccountProperties").fetch("type")

      expect(openapi.reference_of(property)).to be == [nil, nil]
    end

    it "treats a reference to an object schema as nested" do
      property = openapi.properties_of("AvailableBudgetProperties").fetch("spent_in_budgets")

      expect(openapi.reference_of(property)).to be == [:many, "ArrayEntryWithCurrencyAndSum"]
    end
  end
end
