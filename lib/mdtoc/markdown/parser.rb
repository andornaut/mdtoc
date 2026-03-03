# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require_relative 'header'
require_relative 'fragment_generator'

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
        @in_code_block = T.let(false, T::Boolean)
        @in_html_comment = T.let(false, T::Boolean)
      end

      sig { params(lines: T::Enumerable[String]).returns(T::Array[Header]) }
      def headers(lines)
        headers = T.let([], T::Array[Header])
        prev_line = T.let(nil, T.nilable(String))

        lines.each do |line|
          stripped = line.strip

          if skip_line?(line, stripped)
            prev_line = line
            next
          end

          if line.start_with?('#')
            headers << header(line)
          elsif (h = process_setext_header(stripped, prev_line))
            headers << h
          end

          prev_line = line
        end

        headers
      end

      private

      sig { params(line: String, stripped: String).returns(T::Boolean) }
      def skip_line?(line, stripped)
        html_comment?(stripped) || code_block?(line)
      end

      sig { params(stripped: String).returns(T::Boolean) }
      def html_comment?(stripped)
        if stripped.start_with?('<!--')
          @in_html_comment = true unless stripped.end_with?('-->')
          return true
        elsif @in_html_comment && stripped.end_with?('-->')
          @in_html_comment = false
          return true
        end
        @in_html_comment
      end

      sig { params(line: String).returns(T::Boolean) }
      def code_block?(line)
        if line.start_with?('```') && !T.must(line[3..]).strip.end_with?('```')
          @in_code_block = !@in_code_block
          return true
        end
        @in_code_block
      end

      sig { params(stripped: String, prev_line: T.nilable(String)).returns(T.nilable(Header)) }
      def process_setext_header(stripped, prev_line)
        return nil unless prev_line && !prev_line.strip.empty?

        if stripped.match?(/^=+$/)
          HeaderWithFragment.new(@depth, prev_line.strip, @url, generator: @generator)
        elsif stripped.match?(/^-+$/)
          HeaderWithFragment.new(@depth + 1, prev_line.strip, @url, generator: @generator)
        end
      end

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
