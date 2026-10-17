module Async
  module Firefly
    module Environment
      def self.[](name)
        value = ENV[name]

        unless value.nil? || value.empty?
          value
        end
      end

      def self.live?
        !self["FIREFLY_URL"].nil? && !self["FIREFLY_TOKEN"].nil?
      end
    end
  end
end
