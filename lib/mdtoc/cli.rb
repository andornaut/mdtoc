# typed: strict
# frozen_string_literal: true

require 'optparse'
require 'sorbet-runtime'
require 'tempfile'

module Mdtoc
  module CLI
    class << self
      extend T::Sig

      sig { params(args: T::Array[String]).returns(Options) }
      def parse(args)
        parser = OptionParser.new do |parser_|
          parser_.banner = "Usage: #{parser_.program_name} [options] files or directories..."
          parser_.on('-h', '--help', 'Show this message') do
            puts parser_
            exit
          end
          parser_.on('-o', '--output PATH', 'Update a table of contents in the file at PATH')
          parser_.on('-a', '--[no-]append', 'Append to the --output file if a <!-- mdtoc --> tag isn\'t found')
          parser_.on('-c', '--[no-]create', 'Create the --output file if it does not exist')
        end

        options = Options.new
        options.paths = parser.parse(args, into: options)
        if options.paths.empty?
          warn('Specify at least one file or directory to read')
          exit(1)
        end
        options
      end
    end

    class Options < T::Struct
      extend T::Sig

      prop :append, T::Boolean, default: false
      prop :create, T::Boolean, default: false
      prop :output, T.nilable(String)
      prop :paths, T::Array[String], default: []

      sig { params(key: Symbol, val: T.untyped).returns(T.untyped) }
      def []=(key, val)
        send("#{key}=", val)
      end
    end
  end
end
