# Simple Chess

This is a simple chess application created with rails 5.2 and Ruby 2.6

The game is turn-based and has no time limit on moves. It supports castling and en-passant and automatically detects once a player has been placed in checkmate.

## Setup

You can install the dependencies by running:
```sh
bundle install
```

Initialize the database with:
```sh
rails db:create
rails db:schema:load
```

## Tests
Tests can be run with:
```sh
bundle exec rspec
```

Alternatively, you can use guard:
```sh
bundle exec guard
```

You can additionally run Rubocop to check for style errors:
```sh
bundle exec rubocop
```