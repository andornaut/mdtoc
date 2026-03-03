# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require_relative 'header'

module Mdtoc
  module Markdown
    class Parser
      extend T::Sig

      sig do
        params(
          depth: Integer,
          url: String,
          generator: FragmentGenerator
        ).void
      end
      def initialize(depth, url, generator: FragmentGenerator::GitHub.new)
        @depth = depth
        @url = url
        @generator = generator
      end

      sig { params(lines: T::Enumerable[String]).returns(T::Array[Header]) }
      def headers(lines)
        headers = T.let([], T::Array[Header])
        in_code_block = T.let(false, T::Boolean)
        in_html_comment = T.let(false, T::Boolean)
        prev_line = T.let(nil, T.nilable(String))

        lines.each do |line|
          # Handle HTML comments
          if line.strip.start_with?('<!--') && !line.strip.end_with?('-->')
            in_html_comment = true
            next
          elsif in_html_comment && line.strip.end_with?('-->')
            in_html_comment = false
            next
          end
          next if in_html_comment

          # Handle Code blocks
          if line.start_with?('```') && !T.must(line[3..]).strip.end_with?('```')
            in_code_block = !in_code_block
            next
          end
          next if in_code_block

          # Handle ATX headers (# Title)
          if line.start_with?('#')
            headers << header(line)
            prev_line = line
            next
          end

          # Handle Setext headers (Title \n ===)
          if prev_line && !prev_line.strip.empty?
            if line.strip.match?(/^=+$/)
              headers << HeaderWithFragment.new(@depth, prev_line.strip, @url, generator: @generator)
            elsif line.strip.match?(/^-+$/)
              headers << HeaderWithFragment.new(@depth + 1, prev_line.strip, @url, generator: @generator)
            end
          end

          prev_line = line
        end

        headers
      end

      private

      sig { params(line: String).returns(HeaderWithFragment) }
      def header(line)
        m = T.must(line.strip.match(/^(#+)\s*(.*)$/))
        num_hashes = m[1]&.count('#') || 1
        depth = @depth + num_hashes - 1
        label = m[2] || ''
        HeaderWithFragment.new(depth, label, @url, generator: @generator)
      end
    end
  end
end
