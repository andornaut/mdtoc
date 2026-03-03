# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

module Mdtoc
  module Markdown
    module FragmentGenerator
      extend T::Sig
      extend T::Helpers

      interface!

      sig { abstract.params(label: String).returns(String) }
      def generate(label); end

      class GitHub
        extend T::Sig
        include FragmentGenerator

        sig { override.params(label: String).returns(String) }
        def generate(label)
          # GitHub's fragment generation:
          # 1. Downcase
          # 2. Replace spaces with dashes
          # 3. Remove non-alphanumeric characters (keeping dashes and underscores)
          label.downcase.tr(' ', '-').gsub(/[^\w-]/, '')
        end
      end
    end
  end
end
