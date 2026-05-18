# Surveys

A minimal Rails 8 survey tool. Users can create surveys with a single yes/no
question and respond to them any number of times. The home page lists every
survey alongside its aggregate yes/no result.

## Stack

- Ruby 3.4.3
- Rails 8.1
- SQLite (development, test, and production)
- Tailwind CSS via `tailwindcss-rails`
- Hotwire (Turbo + Stimulus) — Rails 8 defaults
- RSpec, FactoryBot, Capybara + Selenium for tests

## Prerequisites

- Ruby 3.4.3 (a `.ruby-version` file is included for rbenv / asdf / chruby)
- Bundler (`gem install bundler` if not already installed)
- For running the system spec only: Google Chrome (headless Chrome via Selenium)

No Node.js is required — `tailwindcss-rails` ships the standalone Tailwind
binary.

## Setup

```bash
bin/setup
```

`bin/setup` installs gem dependencies, prepares the database (creates the
SQLite file and runs migrations), and is safe to re-run.

If you prefer to run the steps manually:

```bash
bundle install
bin/rails db:prepare
```

## Running the app

```bash
bin/dev
```

This starts the Rails server alongside the Tailwind CSS watcher (defined in
`Procfile.dev`). Visit <http://localhost:3000>.

## Running the tests

```bash
bundle exec rspec
```

The suite includes:

- Model specs for `Survey` and `Response` (validations, associations, result
  math, the `with_response_stats` aggregation scope).
- Request specs for the survey and response controllers.
- One end-to-end system spec that drives a real (headless) browser through the
  create-survey / respond / view-results flow.

The system spec requires Google Chrome. To skip it:

```bash
bundle exec rspec --exclude-pattern "spec/system/**/*_spec.rb"
```

## How it works

Two tables back the app:

- `surveys(question:string, timestamps)`
- `responses(survey_id, answer:boolean, timestamps)` — `answer` is `true` for
  yes and `false` for no. `created_at` records when each response was saved.

The home page (`SurveysController#index`) renders surveys using
`Survey.with_response_stats`, a scope that aggregates totals in a single SQL
query to avoid N+1s when many surveys are listed.

## Scope and design decisions

This implementation intentionally keeps the surface area small. The following
are deliberate, documented choices rather than oversights:

- **Authentication is not included.** Surveys and responses are public; adding
  user accounts is straightforward but outside the scope of this exercise.
- **Surveys are immutable from the UI** — there is no edit or destroy action.
  The data model supports deletion (responses cascade via the `survey_id`
  foreign key with `on_delete: :cascade`), so the capability can be exposed
  in a controller action when needed.
- **Multiple responses per visitor are permitted by design.** No uniqueness
  constraint is enforced on `(survey_id, respondent)`; aggregate results
  reflect raw response counts. Per-visitor deduplication (cookie- or
  account-scoped) is a natural follow-up.
- **The index view is unpaginated.** `Survey.with_response_stats` runs a
  single aggregate query, so the page scales well into the low thousands of
  surveys; pagination (e.g. via Kaminari or Pagy) would be the next step
  beyond that.
