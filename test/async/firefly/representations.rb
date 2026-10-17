require "async/firefly"
require "async/firefly/openapi"
require "async/firefly/representation_context"

Async::Firefly::Representation.subclasses.sort_by(&:name).each do |klass|
  entity = klass.schema

  if Async::Firefly::OpenAPI.read_for(entity) || Async::Firefly::OpenAPI.schema_for(entity)
    describe klass do
      it_behaves_like Async::Firefly::RepresentationContext
    end
  end
end
