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

      sig { returns(String) }
      def to_s
        prefix = ' ' * 2 * @depth
        "#{prefix}* [#{@label}](#{@url})"
      end

      sig { params(relative_to_depth: Integer).returns(T::Boolean) }
      def top_level?(relative_to_depth)
        @depth == relative_to_depth
      end
    end

    class HeaderWithFragment < Header
      sig { params(depth: Integer, label: String, url: String).void }
      def initialize(depth, label, url)
        url = "#{url}##{label.downcase.strip.gsub(/ /, '-').gsub(/[^\w\- ]/, '')}"
        super
      end
    end
  end
end
