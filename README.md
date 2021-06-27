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

Create a `Rakefile` with the contents below, then run
[`rake`](https://github.com/ruby/rake) to:

* `git pull`
* `git add` any *.md files
* Run `mdtoc` to update the generated table of contents in the ./README.md file
* Git commit and push any changes

```
task default: %w[mdtoc]

desc 'Update Markdown table of contents and push changes to the git repository'
task :mdtoc do
  command = <<~CMD
    set -e
    git pull
    if [ -n "$(git diff --name-only --diff-filter=U)" ]; then
      echo 'Error: conflicts exist' >&2
      exit 1
    fi
    mdtoc --append --create --output README.md docs/
    git add *.md **/*.md
    git commit -m 'Update TOC'
    git push
  CMD
  %x|#{command}|
end
```

See [andornaut/til](https://github.com/andornaut/til/blob/master/Rakefile) for an example.

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

# Run mdtoc with test inputs, and write to a newly created output file
$ f=$(mktemp) && ruby -Ilib bin/mdtoc -aco ${f} test/samples ; cat ${f}
```
