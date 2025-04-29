# typed: strict
# frozen_string_literal: true

module Mdtoc
  module Writer
    COMMENT_BEGIN = "<!-- mdtoc -->"
    COMMENT_END = "<!-- mdtoc-end -->"

    class << self
      extend T::Sig

      sig { params(toc: String, path: String, append: T::Boolean, create: T::Boolean).void }
      def write(toc, path, append, create)
        validate_path(path, create)
        new_content = content(toc, path, append)
        File.open(path, "w") do |f|
          f.write(new_content)
        end
      end

      private

      sig { params(toc: String, path: String, append: T::Boolean).returns(String) }
      def content(toc, path, append)
        toc = "#{COMMENT_BEGIN}\n#{toc}\n#{COMMENT_END}"

        begin
          f = File.open(path)
        rescue
          # If File.open failed because the file didn't exist, then we know that --create
          # was specified due to the validation in validate_path.
          return "#{toc}\n"
        end
        begin
          old_content = T.must(f.read)
        ensure
          f.close
        end

        if Regexp.new(Regexp.escape(COMMENT_BEGIN), Regexp::IGNORECASE).match?(old_content)
          return old_content.gsub(
            /#{Regexp.escape(COMMENT_BEGIN)}(.*#{Regexp.escape(COMMENT_END)})?/im, toc
          )
        elsif append
          return "#{old_content}\n#{toc}\n"
        end

        warn("Could not update #{path}, because the target HTML tag \"#{COMMENT_BEGIN}\" was not found")
        exit(1)
      end

      sig { params(path: String, create: T::Boolean).void }
      def validate_path(path, create)
        if File.exist?(path)
          unless File.file?(path)
            warn("--output PATH \"#{path}\" is not a regular file")
            exit
          end
        elsif !create
          warn("--output PATH \"#{path}\" does not exist. Specify --create to create it.")
          exit
        end
      end
    end
  end
end
