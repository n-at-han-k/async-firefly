require_relative "page"

module Async
  module Firefly
    class RuleAction < Representation
      def id = self.value[:id]

      def created_at = self.value[:created_at]

      def updated_at = self.value[:updated_at]

      def type = self.value[:type]

      def value_attribute = self.value[:value]

      def order = self.value[:order]

      def active = self.value[:active]

      def stop_processing = self.value[:stop_processing]
    end

    class RuleTrigger < Representation
      def id = self.value[:id]

      def created_at = self.value[:created_at]

      def updated_at = self.value[:updated_at]

      def type = self.value[:type]

      def value_attribute = self.value[:value]

      def prohibited = self.value[:prohibited]

      def order = self.value[:order]

      def active = self.value[:active]

      def stop_processing = self.value[:stop_processing]
    end

    class Rule < Representation
      def created_at = self.attributes[:created_at]

      def updated_at = self.attributes[:updated_at]

      def title = self.attributes[:title]

      def description = self.attributes[:description]

      def rule_group_id = self.attributes[:rule_group_id]

      def rule_group_title = self.attributes[:rule_group_title]

      def order = self.attributes[:order]

      def trigger = self.attributes[:trigger]

      def active = self.attributes[:active]

      def strict = self.attributes[:strict]

      def stop_processing = self.attributes[:stop_processing]

      def triggers = self.nested_list(RuleTrigger, self.attributes[:triggers])

      def actions = self.nested_list(RuleAction, self.attributes[:actions])

      def active? = self.active == true

      def test(**parameters) = RuleTestPage.new(@resource.with(path: "test", parameters: parameters))

      def fire(**parameters) = self.discard(@resource.with(path: "trigger", parameters: parameters), method: :post)

      def update(payload) = self.submit(Rule, @resource, payload, method: :put)

      def delete = self.discard(@resource)
    end

    class RulePage < Page
      MEMBER = Rule
    end

    class RuleTestPage < Page
      def member_class = Transaction

      def member_path(record) = "../../../transactions/" + self.identifier(record, :id)
    end

    class RuleExpressionValidity < Representation
      def valid = self.value[:valid]
    end

    module Rules
      def rules(**parameters) = Collection.for(self, "v1/rules", RulePage, **parameters)

      def rule(id) = Rule.new(self.with(path: "v1/rules/" + Firefly.escape(id)))

      def create_rule(payload) = self.submit(Rule, self.with(path: "v1/rules"), payload, identify: true)

      def validate_rule_expression(expression) = RuleExpressionValidity.new(self.with(path: "v1/rules/validate-expression", parameters: {expression: expression}))
    end
  end
end
