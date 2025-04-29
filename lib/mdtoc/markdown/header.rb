# typed: true
# frozen_string_literal: true

require "sorbet-runtime"

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
        @label = normalize_label(label)
        @url = url
      end

      sig { returns(String) }
      def to_s
        prefix = " " * 2 * @depth
        "#{prefix}* [#{@label}](#{@url})"
      end

      sig { params(relative_to_depth: Integer).returns(T::Boolean) }
      def top_level?(relative_to_depth)
        @depth == relative_to_depth
      end

      private

      def normalize_label(label)
        label = label.strip.tr("\t\n\r", "") # Remove whitespace characters other than spaces.
        label.gsub(/\[(.*)\]\(.*\)/, '\1') # Remove links
      end
    end

    class HeaderWithFragment < Header
      sig { params(depth: Integer, label: String, url: String).void }
      def initialize(depth, label, url)
        super
        @url += "##{@label.downcase.tr(" ", "-").gsub(/[^\w\-]/, "")}"
      end
    end
  end
end
