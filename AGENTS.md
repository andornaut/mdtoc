# Agent Guide

## Setup
```bash
bin/setup
```

## Tasks
- **Test:** `bundle exec rake test`
- **Lint:** `bundle exec rake rubocop`
- **Type Check:** `bundle exec rake sorbet`

## Release
1. Bump version in `lib/mdtoc/version.rb`
2. Run `bundle install` to update `Gemfile.lock`
3. Commit and tag.
