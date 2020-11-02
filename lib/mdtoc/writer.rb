# typed: true
# frozen_string_literal: true

module Mdtoc
  module Writer
    COMMENT_BEGIN = '<!-- mdtoc -->'
    COMMENT_END = '<!-- mdtoc-end -->'

    class << self
      extend T::Sig

      sig { params(toc: String, output_path: String, append: T::Boolean, create: T::Boolean).void }
      def write(toc, output_path, append, create)
        validate_output_path(output_path, create)
        new_content = content(toc, output_path, append)
        File.open(output_path, 'w') do |f|
          f.write(new_content)
        end
      end

      private

      sig { params(toc: String, output_path: String, append: T::Boolean).returns(String) }
      def content(toc, output_path, append)
        toc = "#{COMMENT_BEGIN}\n#{toc}\n#{COMMENT_END}"

        begin
          f = File.open(output_path)
        rescue
          # If File.open failed because the file didn't exist, then we know that --create
          # was specified due to the validation in self.validate_output_path.
          return "#{toc}\n"
        end
        old_content = T.must(f.read)
        f.close

        if Regexp.new(Regexp.escape(COMMENT_BEGIN), Regexp::IGNORECASE).match?(old_content)
          return old_content.gsub(
            /#{Regexp.escape(COMMENT_BEGIN)}(.*#{Regexp.escape(COMMENT_END)})?/im, toc
          )
        elsif append
          return "#{old_content}\n#{toc}\n"
        end

        warn("Could not update #{output_path}, because the target HTML tag \"#{COMMENT_BEGIN}\" was not found")
        exit(1)
      end

      sig { params(output_path: String, create: T::Boolean).void }
      def validate_output_path(output_path, create)
        if output_path
          if File.exist?(output_path)
            unless File.file?(output_path)
              warn("--output PATH \"#{output_path}\" is not a regular file")
              exit
            end
          elsif !create
            warn("--output PATH \"#{output_path}\" does not exist. Specify --create to create it.")
            exit
          end
        end
      end
    end
  end
end
