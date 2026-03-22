# typed: false
# frozen_string_literal: true

require_relative 'lib/mdtoc/version'

Gem::Specification.new do |spec|
  spec.name = 'mdtoc'
  spec.version = Mdtoc::VERSION
  spec.authors = ['andornaut']

  spec.summary = 'Read Markdown files and output a table of contents'
  spec.description = File.read('README.md')
  spec.homepage = 'https://github.com/andornaut/mdtoc'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.executables << 'mdtoc'
  spec.files = Dir['lib/**/*.rb', 'bin/*', 'README.md', 'LICENSE']

  spec.add_development_dependency('minitest', '~> 6.0')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('sorbet')
  # From https://github.com/Shopify/shopify/blob/master/Gemfile
  spec.add_development_dependency('rubocop', '~> 1.50')
  spec.add_development_dependency('rubocop-sorbet', '~> 0.12.0')
  # `unparser` is need by the `Sorbet/SignatureBuildOrder` autocorrect feature.
  spec.add_development_dependency('unparser', '~> 0.8.0')

  spec.add_dependency('sorbet-runtime')
  spec.metadata['rubygems_mfa_required'] = 'true'
end
