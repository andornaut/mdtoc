# typed: true
# frozen_string_literal: true

require 'optparse'
require 'tempfile'
require_relative 'mdtoc/cli'
require_relative 'mdtoc/markdown'
require_relative 'mdtoc/node'
require_relative 'mdtoc/writer'

module Mdtoc
  extend T::Sig

  sig { params(args: T::Array[String]).void }
  def self.main(args)
    options = Mdtoc::CLI::Options.for_args(args)
    toc = Mdtoc::Node.render(options.paths)
    unless options.output
      puts toc
      return
    end

    Mdtoc::Writer.write(toc, T.must(options.output), options.append, options.create)
  end
end

Mdtoc.main(ARGV) if __FILE__ == $PROGRAM_NAME
