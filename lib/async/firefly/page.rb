require_relative "error"
require_relative "representation"

module Async
  module Firefly
    class Page < Representation
      include Enumerable

      MEMBER = Representation

      def records
        case self.value
        in {data: Array => records}
          records
        else
          []
        end
      end

      def pagination
        case self.value
        in {meta: {pagination: Hash => pagination}}
          pagination
        else
          {}
        end
      end

      def total = self.pagination[:total].to_i

      def per_page = self.pagination[:per_page].to_i

      def current_page = self.pagination[:current_page].to_i

      def total_pages = self.pagination[:total_pages].to_i

      def last? = self.current_page >= [self.total_pages, 1].max

      def empty? = self.records.empty?

      def each(&block)
        if block
          self.records.each do |record|
            block.call(self.member_for(record))
          end
        else
          self.to_enum(:each)
        end
      end

      def member_class = self.class::MEMBER

      def member_path(record) = self.identifier(record, :id)

      def identifier(record, *keys)
        value = record.dig(*keys)

        if value.nil? || value.to_s.empty?
          raise Error, self.class.to_s + " cannot address a member: the response carried no " + keys.join(".")
        end

        Firefly.escape(value)
      end

      def member_resource(record)
        @resource.with(path: self.member_path(record), parameters: nil, merge: false)
      end

      def member_for(record)
        self.member_class.new(self.member_resource(record), value: {data: record}, metadata: self.metadata)
      end
    end

    class Collection
      include Enumerable

      DEFAULT_LIMIT = 50

      def self.for(parent, path, page_class, **parameters)
        self.new(parent.with(path: path, parameters: parameters), page_class)
      end

      def initialize(resource, page_class)
        @resource = resource
        @page_class = page_class
      end

      attr :resource

      attr :page_class

      def each_page(limit: DEFAULT_LIMIT, &block)
        if block
          self.walk(limit, &block)
        else
          self.to_enum(:each_page, limit: limit)
        end
      end

      def each(**options, &block)
        if block
          self.each_page(**options) do |page|
            page.each(&block)
          end
        else
          self.to_enum(:each, **options)
        end
      end

      def page(number, limit: DEFAULT_LIMIT)
        @page_class.new(@resource.with(parameters: {page: number, limit: limit}))
      end

      def total
        self.page(1, limit: 1).total
      end

      def walk(limit, &block)
        number = 1

        while true
          page = self.page(number, limit: limit)

          if page.empty?
            break
          end

          block.call(page)

          if page.last?
            break
          end

          number += 1
        end
      end
    end
  end
end
