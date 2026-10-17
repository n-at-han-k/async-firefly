require "async/firefly"

describe "readme.md" do
  let(:source) {::File.read(::File.expand_path("../../../readme.md", __dir__))}

  let(:blocks) {source.scan(/```ruby\n(.*?)```/m).flatten}

  let(:client_methods) {Async::Firefly::Client.instance_methods.map(&:to_s)}

  it "is the gem's name and nothing but fenced ruby blocks" do
    prose = source.lines.each_with_index.reject do |line, index|
      index.zero? || line.strip.empty? || line.start_with?("```")
    end

    inside = self.inside_blocks(source)

    expect(prose.reject{|_, index| inside.include?(index)}).to be == []
  end

  it "parses every block" do
    broken = blocks.each_with_index.filter_map do |block, index|
      begin
        ::RubyVM::AbstractSyntaxTree.parse(block)

        nil
      rescue ::SyntaxError => error
        [index, error.message.lines.first.strip]
      end
    end

    expect(broken).to be == []
  end

  it "calls only names the library defines" do
    code = blocks.join("\n").gsub(/"[^"]*"/, '""')

    unknown = code.scan(/\bfirefly\.([a-z_0-9]+[!?]?)/).flatten.uniq.reject do |name|
      client_methods.include?(name)
    end

    expect(unknown).to be == []
  end

  def inside_blocks(text)
    open = false

    text.lines.each_with_index.filter_map do |line, index|
      if line.start_with?("```")
        open = !open

        nil
      elsif open
        index
      end
    end
  end
end
