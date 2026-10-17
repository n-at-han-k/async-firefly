module Async
  module Firefly
    module Redacted
      SECRET = [
        :access_token,
        :client_secret,
        :code_verifier,
        :password,
        :refresh_token,
        :secret,
        :token,
      ].freeze

      REDACTED = "[redacted]"

      def self.redact(value)
        case value
        when Hash
          value.to_h{|key, nested| SECRET.include?(key) ? [key, REDACTED] : [key, self.redact(nested)]}
        when Array
          value.map{|each| self.redact(each)}
        else
          value
        end
      end

      def inspect
        "\#<" + self.class.to_s + " " + @resource.path.to_s.inspect + " value=" + Redacted.redact(@value).inspect + ">"
      end
    end
  end
end
