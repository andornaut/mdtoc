# mdtoc - Markdown Table of Contents

[![Gem](https://img.shields.io/gem/v/mdtoc)](https://rubygems.org/gems/mdtoc)
[![Release](https://github.com/andornaut/mdtoc/actions/workflows/release.yml/badge.svg)](https://github.com/andornaut/mdtoc/actions/workflows/release.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/license/MIT)

Read Markdown files and output a table of contents.

## Installation

Requirements:

* [Ruby](https://www.ruby-lang.org/en/) (see [.ruby-version](./.ruby-version))

```bash
gem install mdtoc
```

## Usage

```bash
mdtoc --help
Usage: mdtoc [options] files or directories...
    -h, --help                       Show this message
    -o, --output PATH                Update a table of contents in the file at PATH
    -a, --[no-]append                Append to the --output file if a <!-- mdtoc --> tag isn't found
    -c, --[no-]create                Create the --output file if it does not exist
```

1. Add a `<!-- mdtoc -->` tag to a Markdown file.

    ```bash
    echo '<!-- mdtoc -->' >> README.md
    ```

2. Run `mdtoc` and specify input files or directories (eg. the "test/samples" directory) and an output file (eg. "README.md").

    ```bash
    mdtoc -aco README.md test/samples
    ```

## Example Rakefile

Create a `Rakefile` with the contents below, then run
[`rake`](https://github.com/ruby/rake) to:

* Run `mdtoc` to update the generated table of contents in the ./README.md file
* `git add` any `*.md` files
* Git commit, pull, and push any changes

```ruby
task default: %w[mdtoc]

desc 'Update Markdown table of contents and push changes to the git repository'
task :mdtoc do
  command = <<~CMD
    set -e
    if [ -n "$(git diff --name-only --diff-filter=U)" ]; then
      echo 'Error: conflicts exist' >&2
      exit 1
    fi
    mdtoc --append --create --output README.md docs/
    git add README.md docs/*.md
    git commit -qm 'Update TOC' || true
    git pull
    git push
  CMD
  sh command, verbose: false do |ok, status|
    unless ok
      fail "Failed with status: #{status.exitstatus}"
    end
  end
end
```

See [andornaut/til](https://github.com/andornaut/til/blob/main/Rakefile) for an example.

## Developing

Checks require Make and Docker 29.9.3, matching CI. The project-owned containers
live in `tests/container/`. Verification mounts only a read-only source snapshot
and scratch storage.

```bash
make check
bundle exec rake test
bundle exec rake rubocop
bundle exec rake sorbet
bundle exec rake build
```

The full gate runs RuboCop, Sorbet, Markdown lint, the unit suite and gem
packaging. `make build` exports the gem under `pkg/`. Native Rake tasks run on the host.

### Publishing

1. Bump version in `lib/mdtoc/version.rb`
2. Run `bundle install` to update `Gemfile.lock`
3. Commit the changes
4. Tag the commit `vX.Y.Z` and push the tag

Pushing the tag is the whole release. The Release workflow runs the checks,
builds the gem, cuts the GitHub release, and pushes that same gem to RubyGems.
`rake release` is not run by hand.

Nothing here holds a RubyGems API key. The workflow authenticates with a
short-lived credential minted from its own OIDC claim, against a trusted
publisher registered on RubyGems that names this repository and
`.github/workflows/release.yml`. Renaming that file stops publishing until the
trusted publisher is updated to match.
