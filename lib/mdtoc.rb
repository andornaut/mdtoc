# typed: strict
# frozen_string_literal: true

require "optparse"
require "tempfile"
require_relative "mdtoc/cli"
require_relative "mdtoc/node"
require_relative "mdtoc/writer"

module Mdtoc
  class << self
    extend T::Sig

    sig { params(args: T::Array[String]).void }
    def main(args)
      options = Mdtoc::CLI.parse(args)
      toc = Mdtoc::Node.render(options.paths)
      unless options.output
        puts toc
        return
      end

      Mdtoc::Writer.write(toc, T.must(options.output), options.append, options.create)
    end
  end
end

Mdtoc.main(ARGV) if __FILE__ == $PROGRAM_NAME
