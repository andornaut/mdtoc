# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'

module Mdtoc
  module Markdown
    class Header
      extend T::Sig

      sig { params(depth: Integer, label: String, url: String).void }
      def initialize(depth, label, url)
        if depth < 0
          raise ArgumentError, "Header depth must be >= 0, but was #{depth}"
        end
        @depth = depth
        @label = label.strip.gsub(/\s+/, ' ')
        @url = url
      end

      sig { params(relative_to_depth: Integer).returns(T::Boolean) }
      def top_level?(relative_to_depth)
        @depth == relative_to_depth
      end

      sig { returns(String) }
      def to_s
        prefix = ' ' * 2 * @depth
        "#{prefix}* [#{@label}](#{@url})"
      end
    end

    class HeaderWithFragment < Header
      sig { params(depth: Integer, label: String, url: String).void }
      def initialize(depth, label, url)
        url = "#{url}##{label.downcase.strip.gsub(/ /, '-').gsub(/[^\w\-_ ]/, '')}"
        super
      end
    end

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
          if line.start_with?('```') && !T.must(line[3..]).strip.end_with?('```')
            skip = !skip
          end
          next if skip || !line.start_with?('#')

          header(line)
        end
      end

      private

      sig { params(line: String).returns(Header) }
      def header(line)
        m = T.must(line.strip.match(/^(#+)\s*(.*)$/))
        num_hashes = m[1]&.count('#') || 1
        depth = @depth + num_hashes - 1
        label = m[2] || ''
        HeaderWithFragment.new(depth, label, @url)
      end
    end
  end
end
