require_relative "page"

module Async
  module Firefly
    class RuleGroup < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def title = self.attributes[:title]

      def description = self.attributes[:description]

      def order = self.attributes[:order]

      def active = self.attributes[:active]

      def active? = self.active == true

      def rules(**parameters) = Collection.for(@resource, "rules", RuleGroupRulePage, **parameters)

      def test(**parameters) = Collection.for(@resource, "test", RuleGroupTestPage, **parameters)

      def fire(**parameters) = self.discard(@resource.with(path: "trigger", parameters: parameters), method: :post)

      def update(payload) = self.submit(RuleGroup, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class RuleGroupPage < Page
      MEMBER = RuleGroup
    end

    class RuleGroupRulePage < Page
      def member_class = Rule

      def member_path(record) = "../../../rules/" + self.identifier(record, :id)
    end

    class RuleGroupTestPage < Page
      def member_class = Transaction

      def member_path(record) = "../../../transactions/" + self.identifier(record, :id)
    end

    module RuleGroups
      def rule_groups(**parameters) = Collection.for(self, "v1/rule-groups", RuleGroupPage, **parameters)

      def rule_group(id) = RuleGroup.new(self.with(path: "v1/rule-groups/" + Firefly.escape(id)))

      def create_rule_group(payload) = self.submit(RuleGroup, self.with(path: "v1/rule-groups"), payload, identify: true)
    end
  end
end
