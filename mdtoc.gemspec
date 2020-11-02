# typed: false
# frozen_string_literal: true

require_relative 'lib/mdtoc/version'

Gem::Specification.new do |spec|
  spec.name = 'mdtoc'
  spec.version = Mdtoc::VERSION
  spec.summary = 'Read Markdown files and output a table of contents'
  spec.authors = ['andornaut']
  spec.executables << 'mdtoc'
  spec.files = Dir['lib/**/*.rb'] + Dir['test/**/*']
  spec.homepage = 'https://github.com/andornaut/mdtoc'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.2'

  spec.add_development_dependency('minitest', '~> 5')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('sorbet')
  # From https://github.com/Shopify/shopify/blob/master/Gemfile
  spec.add_development_dependency('rubocop', '~> 0.86')
  spec.add_development_dependency('rubocop-shopify', '>= 1.0.4')
  spec.add_development_dependency('rubocop-sorbet', '~> 0.5')
  # `unparser` is need by the `Sorbet/SignatureBuildOrder` autocorrect feature.
  spec.add_development_dependency('unparser', '~> 0.4.9')

  spec.add_runtime_dependency('sorbet-runtime')
end
