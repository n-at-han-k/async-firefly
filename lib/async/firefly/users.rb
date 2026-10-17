require_relative "page"

module Async
  module Firefly
    class User < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def email = self.attributes[:email]

      def blocked = self.attributes[:blocked]

      def blocked_code = self.attributes[:blocked_code]

      def role = self.attributes[:role]

      def update(payload) = self.submit(User, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class UserPage < Page
      MEMBER = User
    end

    module Users
      def users(**parameters) = Collection.for(self, "v1/users", UserPage, **parameters)

      def user(id) = User.new(self.with(path: "v1/users/" + Firefly.escape(id)))

      def create_user(payload) = self.submit(User, self.with(path: "v1/users"), payload, identify: true)
    end
  end
end
