# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require_relative "header"

module Mdtoc
  module Markdown
    class Parser
      extend T::Sig

      sig { params(depth: Integer, url: String).void }
      def initialize(depth, url)
        @depth = depth
        @url = url
      end

      sig { params(lines: T::Enumerable[String]).returns(T::Array[Header]) }
      def headers(lines)
        # TODO: Skip headers within multi-line comments.
        # TODO: Handle --- and === style headers.
        skip = T.let(false, T::Boolean)
        lines.filter_map do |line|
          # Skip code blocks.
          if line.start_with?("```") && !T.must(line[3..]).strip.end_with?("```")
            skip = !skip
          end
          next if skip || !line.start_with?("#")

          header(line)
        end
      end

      private

      sig { params(line: String).returns(HeaderWithFragment) }
      def header(line)
        m = T.must(line.strip.match(/^(#+)\s*(.*)$/))
        num_hashes = m[1]&.count("#") || 1
        depth = @depth + num_hashes - 1
        label = m[2] || ""
        HeaderWithFragment.new(depth, label, @url)
      end
    end
  end
end
