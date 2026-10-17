# async-firefly ruby gem

## Important

* Read the async-rest skill before doing anything
* This project uses nix flakes... every command should be prefixed with `nix develop --command`.

## Testing

```bash
nix develop --command bundle exec sus
docker compose up -d --wait
eval "$(bin/firefly-bootstrap)"
docker compose down -v
```

Live tests skip unless `FIREFLY_URL`/`FIREFLY_TOKEN` are set.

Firefly III needs three things Vikunja did not: an `APP_KEY` of exactly 32 characters, a Passport
personal access client, and a user. `bin/firefly-bootstrap` creates the last two - it runs
`php artisan passport:client --personal` through the container, registers over the web form, and
issues a token through Passport's own endpoint, because the image ships neither a create-user
command nor tinker.

## Rubocop

```bash
nix develop --command bundle exec rubocop --cache false
nix develop --command bundle exec rubocop --cache false -A
```

`--cache false` is required: the cops read `data/openapi-v1.yaml`, which is not in RuboCop's cache
key.

## What the document says, and what the cops check

The API is JSON:API-ish. `XSingle` is `{data: XRead}`, `XArray` is `{data: [XRead], meta: Meta}`,
and `XRead` is `{type, id, attributes}`. So a representation is named after its `XRead` schema with
`Read` stripped, and its accessors read `self.attributes[:key]`. The attribute schema is found by
following `properties.attributes.$ref`, and the names are irregular: `AccountRead` holds
`AccountProperties`, `TagRead` holds `TagModel`, `RuleRead` holds `Rule`. `PiggyBankAccountRead` has
no `attributes` at all, so it is read through `self.data`.

The cops under `cops/` check the client against the document rather than against taste:

* `EntityHasRepresentation` - every schema an operation answers with has a representation.
  `.rubocop_todo.yml` lists what is not written yet.
* `AccessorMatchesSchema` - a representation reads every attribute of its schema and no key the
  document does not describe, across the three shapes: `self.attributes`, `self.data`, `self.value`.
* `AccessorNamesProperty` - an accessor is named after what it reads.
* `CreateIdentifiesResource` - a `create_*` method says what identifies the resource it created.
  `identify: true` appends the answered id, `identify: :code` appends an attribute instead - which
  currencies need, because they are addressed by code - and `identify: nil` says the API publishes
  no identifier for it.
* `ShadowedConstant` - `Async::Firefly::Data` shadows `::Data` inside the namespace, so a bare
  `Data.` there is an error waiting to happen.

`fixtures/async/firefly/representation_context.rb` is the other half: a schema-driven fixture that
builds a sample envelope per entity and asserts each accessor reads its own attribute, that a `$ref`
to an object arrives as a representation while a `$ref` to a string enum stays a scalar, that an
absent value stays absent, and that credentials are masked. `test/async/firefly/representations.rb`
applies it to every `Representation.subclasses`, so coverage follows the classes.

`test/async/firefly/conformance.rb` establishes conformance the way rule 11 asks: it walks every
method reachable from the client against a recording server and asserts what went over the wire.
