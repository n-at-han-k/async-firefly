# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-10-17

### Added

- `Async::Firefly::Client`, an `Async::REST::Resource` for the Firefly III v1 API.
  `Client.open(url)` takes the API root, falling back to `FIREFLY_URL` and then to
  `http://localhost:8080/api/`. `#authenticated(token)` returns a client carrying
  the personal access token as a bearer credential; every request sends a
  `user-agent` naming the gem and its version, and asks for
  `application/vnd.api+json`, which is what most of the API answers with.
- Every operation the vendored OpenAPI document describes, reachable from the
  client: accounts, transactions and their splits, bills and subscriptions,
  budgets and budget limits, categories, tags, piggy banks, object groups,
  currencies and exchange rates, recurrences, rules and rule groups, webhooks and
  their messages and attempts, attachments, link types and transaction links,
  preferences, configuration, users and user groups, the autocomplete endpoints,
  the insight reports, the charts, the summary, the data exports, and search.
- `Async::Firefly::Representation`, the base for every response, which reads the
  API's JSON:API envelope: `#data` is the record, `#attributes` its attributes,
  and `#id` and `#type` the identity it carries. Each class reads the attributes
  its schema describes and nothing else, so `account.current_balance` and
  `transaction.transactions.first.description` work without a second request.
  `#deconstruct_keys` and `#deconstruct` make a representation matchable with
  `case`/`in`, and `#cacheable?` reports whether the response may be held on to.
- `Async::Firefly::Page` and `Async::Firefly::Collection` for the paginated
  listings. A collection is `Enumerable` — `#each` walks every page, while
  `#each_page(limit:)` hands over each `Page`, which exposes `#records`,
  `#total`, `#count`, `#per_page`, `#current_page`, `#total_pages` and `#last?`
  from the envelope's `meta.pagination`. Members come back addressed at their own
  published identifier, which for a currency is its code and for a tag its name
  rather than the numeric id the envelope also carries.
- `Async::Firefly::Download` for the endpoints that answer bytes rather than
  JSON — attachment downloads and the data exports — and
  `Async::Firefly::Upload` for the one that takes an `application/octet-stream`
  body. `#bytes` is the body and `#media_type` the content type.
- `Async::Firefly::Failure`, raised for any unsuccessful response, with
  `#status`, `#detail`, `#exception_class`, `#errors`, `#invalid?` and
  `#retry_after` read off the body — including the field errors a `422` carries.
  It descends from `Async::REST::ResponseError`. `Async::Firefly::Error` is the
  other class this gem raises, for a `Page` that cannot address a member, so
  rescuing both covers everything the gem raises.
- Rate-limit handling in `Async::Firefly::Submit`: a `429` with a usable
  `retry-after` is retried, up to 4 attempts and a 30 second ceiling per wait.
- `Async::Firefly::Redacted`, which masks credentials in `#inspect`: a token,
  password or secret prints as `[redacted]`, while `#value` is untouched.
- `Async::Firefly::VERSION`.
- Requires Ruby 3.3 or later, and `async-rest` ~> 0.20.
