require "async/rest/error"

module Async
  module Firefly
    class Error < StandardError
    end

    class Failure < Async::REST::ResponseError
      def self.for(response)
        self.new(response, self.problem_for(self.payload_of(response)))
      end

      def self.payload_of(response)
        response.read
      rescue StandardError => error
        error.message
      end

      def self.problem_for(payload)
        case payload
        in Hash => problem
          problem
        else
          {message: payload.to_s}
        end
      end

      def self.summary_of(problem)
        problem[:message] || problem[:exception] || problem.inspect
      end

      def initialize(response, problem = {})
        super(response)

        @problem = problem
      end

      attr :problem

      def message = self.status.to_s + ": " + self.class.summary_of(@problem)

      def to_s = self.message

      def status = @response.status

      def retry_after = @response.headers["retry-after"]

      def detail = @problem[:message]

      def exception_class = @problem[:exception]

      def errors = @problem.fetch(:errors, {})

      def invalid? = !self.errors.empty?
    end
  end
end
