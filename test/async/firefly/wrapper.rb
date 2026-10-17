require "async/firefly"

describe Async::Firefly::Wrapper do
  let(:wrapper) {subject.new}

  def response_for(content_type)
    ::Protocol::HTTP::Response[200, {"content-type" => content_type}, []]
  end

  with "#parser_for" do
    it "parses what the API answers most operations with" do
      expect(wrapper.parser_for(self.response_for("application/vnd.api+json"))).to be == Async::REST::Wrapper::JSON::Parser
    end

    it "parses plain JSON, which the other operations answer" do
      expect(wrapper.parser_for(self.response_for("application/json"))).to be == Async::REST::Wrapper::JSON::Parser
    end

    it "leaves an export as the bytes that arrived" do
      expect(wrapper.parser_for(self.response_for("application/octet-stream"))).to be_nil
    end

    it "leaves a translated response as the bytes that arrived" do
      expect(wrapper.parser_for(self.response_for("text/html"))).to be_nil
    end

    it "leaves a response declaring nothing alone" do
      expect(wrapper.parser_for(::Protocol::HTTP::Response[204, {}, nil])).to be_nil
    end
  end

  with "#prepare_request" do
    it "asks for the API's own media type and sends plain JSON" do
      request = ::Protocol::HTTP::Request["POST", "/api/v1/accounts"]

      wrapper.prepare_request(request, {name: "Savings"})

      expect(request.headers["accept"]).to be == ["application/vnd.api+json", "application/json"]
      expect(request.headers["content-type"]).to be == "application/json"
      expect(request.body.join).to be == ::JSON.dump({name: "Savings"})
    end
  end

  with "#response_for" do
    it "performs exactly one request" do
      calls = 0

      resource = ::Protocol::HTTP::Middleware.for do |request|
        calls += 1

        ::Protocol::HTTP::Response[429, {"retry-after" => "0.01"}, []]
      end

      response = wrapper.response_for(resource, ::Protocol::HTTP::Request["GET", "/api/v1/accounts"])

      expect(response.status).to be == 429
      expect(calls).to be == 1
    end
  end
end

describe Async::Firefly::Binary do
  let(:wrapper) {subject.new}

  it "sends the bytes as they are, and leaves the type to the resource" do
    request = ::Protocol::HTTP::Request["POST", "/api/v1/attachments/1/upload"]

    wrapper.prepare_request(request, "hello")

    expect(request.headers["content-type"]).to be_nil
    expect(request.body.join).to be == "hello"
  end
end

describe Async::Firefly::Content do
  let(:wrapper) {subject.new}

  it "asks for an octet stream and reads the body as it arrived" do
    request = ::Protocol::HTTP::Request["GET", "/api/v1/data/export/accounts"]

    wrapper.prepare_request(request, nil)

    expect(request.headers["accept"]).to be == ["application/octet-stream"]
    expect(wrapper.parser_for(::Protocol::HTTP::Response[200, {"content-type" => "text/csv"}, ["a,b\n"]])).to be_nil
  end
end

describe Async::Firefly::Failure do
  def response_for(status, body, headers = {})
    case body
    when Hash
      chunk = ::JSON.dump(body)
    else
      chunk = body
    end

    ::Protocol::HTTP::Response[status, {"content-type" => "application/json"}.merge(headers), [chunk]]
  end

  it "reads the meaning of the failure from the body" do
    response = self.response_for(404, {message: "Resource not found", exception: "NotFoundHttpException"})
    response.body = Async::REST::Wrapper::JSON::Parser.new(response.body)

    failure = subject.for(response)

    expect(failure.status).to be == 404
    expect(failure.detail).to be == "Resource not found"
    expect(failure.exception_class).to be == "NotFoundHttpException"
    expect(failure.message).to be == "404: Resource not found"
    expect(failure.invalid?).to be == false
  end

  it "keeps the field errors a validation failure carries" do
    response = self.response_for(422, {message: "The given data was invalid.", errors: {name: ["The name field is required."]}})
    response.body = Async::REST::Wrapper::JSON::Parser.new(response.body)

    failure = subject.for(response)

    expect(failure.invalid?).to be == true
    expect(failure.errors).to be == {name: ["The name field is required."]}
  end

  it "keeps a body it could not read as the detail" do
    failure = subject.for(self.response_for(502, "<html>502</html>"))

    expect(failure.status).to be == 502
    expect(failure.detail).to be == "<html>502</html>"
  end
end

describe Async::Firefly::Representation do
  let(:resource) {Async::Firefly::Client.new(nil, ::Protocol::URL::Reference.parse("/api/v1/accounts/1"))}

  it "reads the record and its attributes out of the envelope" do
    representation = subject.new(resource, value: {data: {type: "accounts", id: "1", attributes: {name: "Savings"}}})

    expect(representation.id).to be == "1"
    expect(representation.type).to be == "accounts"
    expect(representation.attributes).to be == {name: "Savings"}
  end

  it "reports an envelope it did not get as no record at all" do
    representation = subject.new(resource, value: {})

    expect(representation.data).to be == {}
    expect(representation.attributes).to be == {}
    expect(representation.id).to be_nil
  end

  it "discriminates the kind of representation that arrived" do
    representation = subject.new(resource, value: {data: {id: "1", attributes: {name: "Savings"}}})

    matched = nil

    case representation
    in {data: {attributes: {name: String => name}}}
      matched = name
    end

    expect(matched).to be == "Savings"
  end
end

describe Async::Firefly::Page do
  let(:resource) {Async::Firefly::Client.new(nil, ::Protocol::URL::Reference.parse("/api/v1/accounts"))}

  let(:page) do
    subject.new(resource, value: {
      data: [{type: "accounts", id: "7", attributes: {name: "Savings"}}],
      meta: {pagination: {total: 3, count: 1, per_page: 1, current_page: 2, total_pages: 3}},
    })
  end

  it "reads the pagination the envelope carries" do
    expect(page.total).to be == 3
    expect(page.count).to be == 1
    expect(page.per_page).to be == 1
    expect(page.current_page).to be == 2
    expect(page.total_pages).to be == 3
    expect(page.last?).to be == false
  end

  it "identifies each member independently of the collection" do
    member = page.first

    expect(member.resource.reference.to_s).to be == "/api/v1/accounts/7"
    expect(member.id).to be == "7"
  end
end

describe Async::Firefly::Redacted do
  it "masks every key that names a credential" do
    redacted = subject.redact({secret: "s", nested: {password: "p", name: "keep"}, list: [{token: "t"}]})

    expect(redacted).to be == {
      secret: "[redacted]",
      nested: {password: "[redacted]", name: "keep"},
      list: [{token: "[redacted]"}],
    }
  end
end
