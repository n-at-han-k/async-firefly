require "async/firefly"
require "async/firefly/server_context"
require "async/firefly/openapi"

describe Async::Firefly::Client do
  include_context Async::Firefly::ServerContext

  let(:members) {[]}

  def words = /query|email|password|code|name|title|type|date|start|end|tag|kind|entity|provider|mode|object/

  def sample = {id: "1", name: "tester", code: "EUR", tag: "example"}

  def record = {type: "example", id: "7", attributes: sample}

  def envelope = {data: [record], meta: {pagination: {total: 1, count: 1, per_page: 1, current_page: 1, total_pages: 1}}}

  def methods_of(path) = ["GET", "PUT", "PATCH", "POST", "DELETE"]

  def value_for(name)
    text = name.to_s

    if text.match?(/payload|body|attributes/)
      {}
    elsif text.match?(/bytes|contents/)
      "example"
    elsif text.match?(words)
      "example"
    else
      1
    end
  end

  def arguments_for(method)
    positional = []
    keywords = {}

    method.parameters.each do |kind, name|
      case kind
      when :req
        positional << self.value_for(name)
      when :keyreq
        keywords[name] = self.value_for(name)
      end
    end

    [positional, keywords]
  end

  def call_method(object, name)
    method = object.method(name)
    positional, keywords = self.arguments_for(method)

    if keywords.empty?
      method.call(*positional)
    else
      method.call(*positional, **keywords)
    end
  rescue StandardError
    nil
  end

  def force(result)
    case result
    when Async::Firefly::Collection
      result.first
    when Async::Firefly::Representation
      result.value
    end
  rescue StandardError
    nil
  end

  def collect_members(collection)
    page = collection.page_class.new(collection.resource.with(parameters: {page: 1, limit: 1}), value: self.envelope)

    page.each do |member|
      members << [collection.page_class.name, member.resource.reference.path.to_s]
    end
  rescue StandardError
    nil
  end

  def domain_methods(object, base) = (object.class.instance_methods - base.instance_methods).sort

  def visit(object, base, depth)
    self.domain_methods(object, base).each do |name|
      unless name == :authenticated
        self.visit_method(object, name, depth)
      end
    end
  end

  def visit_method(object, name, depth)
    result = self.call_method(object, name)

    if result.is_a?(Async::Firefly::Collection)
      self.collect_members(result)
    end

    self.force(result)

    if depth > 0 && self.further?(result)
      seeded = result.class.new(result.resource, value: {data: self.record})

      self.visit(seeded, Async::Firefly::Representation, depth - 1)
    end
  end

  def further?(result)
    result.is_a?(Async::Firefly::Representation) && !result.is_a?(Async::Firefly::Page)
  end

  def walk
    self.visit(firefly, Async::REST::Resource, 3)
  end

  def report(collection) = collection.map{|request| request[:method] + " " + request[:path]}.uniq.sort

  def documented?(path)
    self.methods_of(path).any? do |method|
      Async::Firefly::OpenAPI.route_for(method, path)
    end
  end

  with "the families the client is assembled from" do
    let(:families) do
      Async::Firefly::Client.included_modules.select do |included|
        included.name.to_s.start_with?("Async::Firefly::") && included != Async::Firefly::Submit
      end
    end

    it "defines each entry point exactly once" do
      counted = families.flat_map{|family| family.instance_methods(false)}.tally

      expect(counted.select{|_, times| times > 1}).to be == {}
    end

    it "never shadows the resource it is mixed into" do
      shadowed = families.flat_map do |family|
        family.instance_methods(false) & Async::REST::Resource.instance_methods
      end

      expect(shadowed.uniq).to be == []
    end
  end

  with "every page the client yields" do
    it "yields members of a representation the document describes" do
      wrong = Async::Firefly::Page.subclasses.reject do |page|
        page::MEMBER <= Async::Firefly::Representation
      end

      expect(wrong).to be == []
    end
  end

  with "every method reachable from the client" do
    it "addresses only routes the document describes" do
      self.walk

      expect(requests.size).to be >= 100
      expect(self.report(undocumented_requests)).to be == []
    end

    it "reaches every route the document describes" do
      self.walk

      reached = requests.filter_map do |request|
        if request[:route]
          request[:method] + " " + Async::Firefly::OpenAPI.prefix + request[:route]
        end
      end

      documented = Async::Firefly::OpenAPI.routes.map{|method, path| method + " " + path}

      expect((documented - reached.uniq).sort).to be == []
    end

    it "sends only query parameters the operation documents" do
      self.walk

      undocumented = requests.flat_map do |request|
        self.unknown_parameters(request).map{|name| request[:route].to_s + " " + name.to_s}
      end

      expect(undocumented.uniq.sort).to be == []
    end

    it "carries the credential on every request" do
      self.walk

      missing = requests.reject{|request| request[:headers]["authorization"]}

      expect(self.report(missing)).to be == []
    end

    it "says what it accepts on every request" do
      self.walk

      missing = requests.reject{|request| request[:headers]["accept"]}

      expect(self.report(missing)).to be == []
    end

    it "accepts a media type the operation answers with" do
      self.walk

      wrong = requests.reject{|request| self.accepts_what_is_answered?(request)}

      expect(self.report(wrong)).to be == []
    end

    it "derives every member at an identifier the document publishes" do
      self.walk

      undocumented = members.reject{|_, path| self.documented?(path)}

      expect(undocumented.uniq.sort).to be == []
    end

    it "derives members without the collection's own parameters" do
      self.walk

      expect(members).not.to be(:empty?)

      carried = members.select{|_, path| path.include?("?")}

      expect(carried.uniq.sort).to be == []
    end
  end

  def answered_types_of(request)
    operation = Async::Firefly::OpenAPI.operation(request[:method], request[:path])

    if operation
      Array(operation.dig("responses", "200", "content")&.keys)
    else
      []
    end
  end

  def accepts_what_is_answered?(request)
    answered = self.answered_types_of(request)
    accepted = Array(request[:headers]["accept"]).flat_map{|value| value.to_s.split(",")}.map{|value| value.split(";").first.strip}

    answered.empty? || accepted.any?{|value| answered.include?(value)}
  end

  def query_parameters_of(method, path)
    operation = Async::Firefly::OpenAPI.operation(method, path)

    if operation
      operation.fetch("parameters", []).filter_map do |parameter|
        resolved = self.resolve(parameter)

        if resolved["in"] == "query"
          resolved["name"]
        end
      end
    else
      []
    end
  end

  def resolve(parameter)
    reference = parameter["$ref"]

    if reference
      Async::Firefly::OpenAPI.document.dig("components", "parameters", reference.split("/").last) || {}
    else
      parameter
    end
  end

  def unknown_parameters(request)
    if request[:query]
      request[:query].keys.map(&:to_s) - self.query_parameters_of(request[:method], request[:path])
    else
      []
    end
  end
end
