require "prism"
require "rubocop"
require "set"

require_relative "support/document"

module RuboCop
  module Cop
    module AsyncFirefly
      class EntityHasRepresentation < Base
        include Document

        MSG = "`%<entity>s` is an entity of the API with no representation: add `class %<entity>s < Representation` under `lib`, or name it under `Pending` until it is written."

        MSG_UNKNOWN = "`%<entity>s` is listed under `Pending` but is not an entity of `%<document>s`: remove it."

        REPRESENTATION = /Representation\z/

        def on_new_investigation
          path = processed_source.file_path

          if path
            library = self.library_for(path)

            if library
              self.check_entities(library)
            end
          end
        end

        private

        def pending
          cop_config.fetch("Pending", [])
        end

        def library_for(path)
          absolute = ::File.expand_path(path)
          segments = absolute.split(::File::SEPARATOR)

          index = segments.rindex("lib")

          if index
            ::File.join(segments[0..index])
          end
        end

        def check_entities(library)
          written = self.representations_in(library)

          self.entities.each do |entity|
            covered = written.include?(entity) || self.pending.include?(entity)

            unless covered
              add_global_offense(format(MSG, entity: entity))
            end
          end

          self.pending.each do |entity|
            unless self.entities.include?(entity)
              add_global_offense(format(MSG_UNKNOWN, entity: entity, document: self.readable))
            end
          end
        end

        def representations_in(library)
          found = Dir.glob(::File.join(library, "**", "*.rb")).flat_map do |file|
            self.representations_of(::Prism.parse_file(file).value)
          end

          found.to_set
        end

        def representations_of(root)
          self.classes_of(root).filter_map do |node|
            superclass = node.superclass

            if superclass && REPRESENTATION.match?(superclass.slice)
              node.constant_path.slice.split("::").last
            end
          end
        end

        def classes_of(root)
          [].tap do |collected|
            frontier = [root]

            until frontier.empty?
              node = frontier.shift

              if node.is_a?(::Prism::ClassNode)
                collected << node
              end

              frontier.concat(node.compact_child_nodes)
            end
          end
        end
      end
    end
  end
end
