# typed: true
# frozen_string_literal: true

require 'optparse'
require 'tempfile'
require_relative 'mdtoc/cli'
require_relative 'mdtoc/markdown'
require_relative 'mdtoc/node'
require_relative 'mdtoc/writer'

module Mdtoc
  class << self
    extend T::Sig

    sig { params(args: T::Array[String]).void }
    def main(args)
      options = Mdtoc::CLI::Options.for_args(args)
      toc = render_toc(options.paths)
      unless options.output
        puts toc
        return
      end

      Mdtoc::Writer.write(toc, T.must(options.output), options.append, options.create)
    end

    private

    sig { params(paths: T::Array[String]).returns(String) }
    def render_toc(paths)
      paths
        .map { |path| Mdtoc::Node.for_path(path).headers }
        .flatten(1)
        .map(&:to_s)
        .join("\n")
    end
  end
end

Mdtoc.main(ARGV) if __FILE__ == $PROGRAM_NAME
