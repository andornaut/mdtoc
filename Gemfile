# typed: false
# frozen_string_literal: true

source 'https://rubygems.org', cooldown: 7

# Dependabot does not read `.ruby-version`, so without this it resolves against
# its own default Ruby and cannot satisfy the gems that require 3.2.
ruby file: '.ruby-version'

gemspec

gem 'ruby_parser' # For Sorbet hidden-definitions generation
gem 'sorted_set' # For Sorbet hidden-definitions generation
gem 'tapioca', '0.19.2', require: false
