# typed: strict
# frozen_string_literal: true

require 'pathname'
require 'sorbet-runtime'
require_relative 'markdown/header'
require_relative 'markdown/parser'

module Mdtoc
  class Node
    extend T::Helpers
    extend T::Sig

    abstract!

    class << self
      extend T::Sig

      sig { params(path: String, depth: Integer).returns(Node) }
      def for_path(path, depth = 0)
        # Ensure that `path` is a relative path, so that all links are relative and therefore portable.
        pathname = Pathname.new(path)
        pathname = pathname.relative_path_from(Dir.pwd) if pathname.absolute?
        pathname.directory? ? DirNode.new(pathname, depth) : FileNode.new(pathname, depth)
      end

      sig { params(paths: T::Array[String]).returns(String) }
      def render(paths)
        headers = paths.flat_map { |path| for_path(path).headers }
        min_depth = headers.map(&:depth).min || 0
        headers.each { |h| h.depth -= min_depth } if min_depth.positive?
        headers.join("\n")
      end
    end

    sig { params(path: Pathname, depth: Integer).void }
    def initialize(path, depth)
      @path = path
      @depth = depth
    end

    sig { abstract.returns(T::Array[Mdtoc::Markdown::Header]) }
    def headers; end

    sig { returns(String) }
    def label
      @path.basename(@path.extname).to_s.gsub(/_+/, ' ').gsub(/\s+/, ' ').capitalize
    end

    class DirNode < Node
      sig { override.returns(T::Array[Mdtoc::Markdown::Header]) }
      def headers
        readme_path = T.let(nil, T.nilable(Pathname))
        children = @path.children.reject do |child|
          if child.basename.to_s.casecmp?('readme.md')
            readme_path = child
            true
          else
            false
          end
        end

        child_headers = children.sort.flat_map do |child|
          Node.for_path(child.to_s, @depth + 1).headers
        end

        return child_headers unless readme_path

        # Include the headers from the README at the beginning.
        readme_headers = FileNode.new(T.must(readme_path), @depth).headers
        readme_headers + child_headers
      end
    end

    class FileNode < Node
      sig { override.returns(T::Array[Mdtoc::Markdown::Header]) }
      def headers
        path_s = @path.to_s
        parser = Markdown::Parser.new(@depth, path_s)
        headers = parser.headers(@path.each_line)
        return headers if headers[0]&.top_level?(@depth)

        headers.unshift(Mdtoc::Markdown::Header.new(@depth, label, path_s))
      end
    end
  end
end
