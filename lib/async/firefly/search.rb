require_relative "page"

module Async
  module Firefly
    class SearchAccountPage < Page
      MEMBER = Account

      def member_path(record) = "../../accounts/" + self.identifier(record, :id)
    end

    class SearchTransactionPage < Page
      def member_class = Transaction

      def member_path(record) = "../../transactions/" + self.identifier(record, :id)
    end

    module Search
      def search_accounts(query:, field:, type: nil, **parameters) = Collection.for(self, "v1/search/accounts", SearchAccountPage, **{query:, field:, type:}.compact, **parameters)

      def search_transactions(query:, **parameters) = Collection.for(self, "v1/search/transactions", SearchTransactionPage, query:, **parameters)

      def count_transactions(external_identifier: nil, internal_reference: nil, notes: nil, description: nil, include_deleted: nil)
        resource = self.with(path: "v1/search/transactions/count", parameters: {external_identifier:, internal_reference:, notes:, description:, include_deleted:}.compact)

        Representation.get(resource) do |target, response|
          unless response.success?
            raise Failure.for(response)
          end

          case response.read
          in {count: Integer => count}
            count
          else
            nil
          end
        end
      end
    end
  end
end
