# typed: true
# frozen_string_literal: true

require 'pathname'
require 'sorbet-runtime'
require_relative 'markdown'

module Mdtoc
  class Node
    extend T::Helpers
    extend T::Sig
    abstract!

    sig { params(path: String, depth: Integer).returns(Node) }
    def self.for_path(path, depth = 0)
      # Ensure that `path` is a relative path, so that all links are relative and therefore portable.
      path = Pathname.new(path)
      path = path.relative_path_from(Dir.pwd) if path.absolute?
      path = path.to_s
      File.directory?(path) ? DirNode.new(path, depth) : FileNode.new(path, depth)
    end

    sig { params(path: String, depth: Integer).void }
    def initialize(path, depth)
      @path = path
      @depth = depth
    end

    sig { returns(String) }
    def label
      File.basename(@path, File.extname(@path))
    end

    sig { abstract.returns(T::Array[Mdtoc::Markdown::Header]) }
    def headers; end
  end

  class DirNode < Node
    sig { override.returns(T::Array[Mdtoc::Markdown::Header]) }
    def headers
      readme_path = T.let(nil, T.nilable(String))
      child_headers = Dir
        .each_child(@path)
        .map { |path| File.join(@path, path) }
        .reject { |path| readme_path = path if File.basename(path).downcase == 'readme.md' }
        .sort!
        .map { |path| Node.for_path(path, @depth + 1).headers }
        .flatten(1)
      return child_headers unless readme_path

      # Include the headers from the README at the beginning.
      readme_headers = FileNode.new(readme_path, @depth).headers
      readme_headers.push(*child_headers)
    end
  end

  class FileNode < Node
    sig { override.returns(T::Array[Mdtoc::Markdown::Header]) }
    def headers
      parser = Markdown::Parser.new(@depth, @path)
      headers = parser.headers(File.foreach(@path))
      return headers if headers[0]&.top_level?(@depth)

      headers.unshift(Mdtoc::Markdown::Header.new(@depth, label, @path))
    end
  end
end
