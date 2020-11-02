# typed: true
# frozen_string_literal: true

require 'optparse'
require 'tempfile'
require_relative 'mdtoc/markdown'
require_relative 'mdtoc/node'
require_relative 'mdtoc/writer'

module Mdtoc
  class << self
    extend T::Sig

    sig { params(args: T::Array[String]).returns(T::Hash[Symbol, String]) }
    def parse_args!(args)
      options = {}
      OptionParser.new do |parser|
        parser.banner = "Usage: #{parser.program_name} [options] files or directories..."
        parser.on('-h', '--help', 'Show this message') do
          puts parser
          exit
        end
        parser.on('-o', '--output PATH', 'Update a table of contents in the file at PATH')
        parser.on('-a', '--[no-]append', 'Append to the --output file if a <!-- mdtoc --> tag isn\'t found')
        parser.on('-c', '--[no-]create', 'Create the --output file if it does not exist')
      end.parse!(args, into: options)
      if args.empty?
        warn('Specify at least one file or directory to read')
        exit(1)
      end
      options
    end

    sig { params(paths: T::Array[String]).returns(String) }
    def render_toc(paths)
      paths
        .map { |path| Mdtoc::Node.for_path(path).headers }
        .flatten(1)
        .map(&:to_s)
        .join("\n")
    end

    sig { params(args: T::Array[String]).void }
    def main(args)
      options = parse_args!(args)
      toc = render_toc(args)
      output_path = options[:output]
      unless output_path
        puts toc
        return
      end

      append = T.cast(options[:append] || false, T::Boolean)
      create = T.cast(options[:create] || false, T::Boolean)
      Mdtoc::Writer.write(toc, output_path, append, create)
    end
  end
end

Mdtoc.main(ARGV) if __FILE__ == $PROGRAM_NAME
