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

        sig { void }
        def initialize
          @counts = T.let(Hash.new(0), T::Hash[String, Integer])
        end

        sig { override.params(label: String).returns(String) }
        def generate(label)
          # GitHub's fragment generation:
          # 1. Downcase
          # 2. Replace spaces with dashes
          # 3. Remove non-alphanumeric characters (keeping dashes, dots and underscores)
          # 4. Remove leading/trailing dashes and dots (common in many implementations)
          fragment = label.downcase.tr(' ', '-').gsub(/[^\w.-]/, '')
          fragment = fragment.gsub(/^[.-]+|[.-]+$/, '')
          
          count = @counts[fragment]
          @counts[fragment] += 1
          
          if count.positive?
            "#{fragment}-#{count}"
          else
            fragment
          end
        end
      end
    end
  end
end
