require_relative "page"

module Async
  module Firefly
    class UserGroupReadMembers < Representation
      def user_id = self.value[:user_id]

      def user_email = self.value[:user_email]

      def you = self.value[:you]

      def roles = self.value[:roles]
    end

    class UserGroup < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def in_use = self.attributes[:in_use]

      def can_see_members = self.attributes[:can_see_members]

      def title = self.attributes[:title]

      def primary_currency_id = self.attributes[:primary_currency_id]

      def primary_currency_code = self.attributes[:primary_currency_code]

      def primary_currency_symbol = self.attributes[:primary_currency_symbol]

      def primary_currency_decimal_places = self.attributes[:primary_currency_decimal_places]

      def members = Array(self.attributes[:members]).map{|member| UserGroupReadMembers.new(@resource, value: member, metadata: self.metadata)}

      def update(payload) = self.submit(UserGroup, @resource, payload, method: :put)
    end

    class UserGroupPage < Page
      MEMBER = UserGroup
    end

    module UserGroups
      def user_groups(**parameters) = Collection.for(self, "v1/user-groups", UserGroupPage, **parameters)

      def user_group(id) = UserGroup.new(self.with(path: "v1/user-groups/" + Firefly.escape(id)))
    end
  end
end
