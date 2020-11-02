# mdtoc - Markdown Table of Contents

Read Markdown files and output a table of contents.

## Installation

Requirements:

* [Ruby](https://www.ruby-lang.org/en/) (see [.ruby-version](./.ruby-version))

```
$ gem install mdtoc
```

## Usage

```
$ mdtoc --help
Usage: mdtoc [options] files or directories...
    -h, --help                       Show this message
    -o, --output PATH                Update a table of contents in the file at PATH
    -a, --[no-]append                Append to the --output file if a <!-- mdtoc --> tag isn't found
    -c, --[no-]create                Create the --output file if it does not exist
```

1. Add a `<!-- mdtoc -->` tag to a Markdown file.
  ```
  $ echo '<!-- mdtoc -->` >> README.md
  ```
2. Run `mdtoc` and specify input files or directories (eg. the "test/samples" directory) and an output file (eg. "README.md").
  ```
  $ mdtoc -aco README.md test/samples
  ```

## Example Rakefile

Run the [rake](https://github.com/ruby/rake) "mdtoc" task to update a table of contents.
See [andornaut/til](https://github.com/andornaut/til) for an example.

```
task(default: %w[mdtoc])

desc 'Update Markdown table of contents and push changes to the git repository'
task(:mdtoc) do |t|
  command = <<~END
    set -e
    git pull
    if [ -n "$(git diff --name-only --diff-filter=U)" ]; then
      echo 'Error: conflicts exist' >&2
      exit 1
    fi
    mdtoc --append --create --output README.md docs/
    git add **/*.md
    git commit -m 'Update TOC'
    git push
  END
  %x|#{command}|
end
```

## Development

### Installation

Requirements:

* [Bundler](https://bundler.io/)

```
# Install dependencies
$ bundle
```

### Usage

```
# List rake tasks
$ rake -T
rake build                 # Build mdtoc-0.0.2.gem into the pkg directory
rake default               # Run the build, rubocop:auto_correct, sorbet and test tasks
rake install               # Build and install mdtoc-0.0.2.gem into system gems
rake install:local         # Build and install mdtoc-0.0.2.gem into system gems without...
rake release[remote]       # Create tag v0.0.2 and build and push mdtoc-0.0.2.gem to ru...
rake rubocop               # Run RuboCop
rake rubocop:auto_correct  # Auto-correct RuboCop offenses
rake sorbet                # Run the Sorbet type checker
rake test                  # Run tests

# Run mdtoc with test inputs
$ ruby -Ilib bin/mdtoc test/samples
```
