# typed: false
# frozen_string_literal: true

require "minitest/autorun"
require "mdtoc/node"

class TestNode < Minitest::Test
  SAMPLE_DIR = File.join(File.dirname(__FILE__), 'samples')

  def test_dir
    expected = <<~END
      * [readme 1](test/samples/a/readme.md#readme-1)
        * [readme 2](test/samples/a/readme.md#readme-2)
          * [readme 3](test/samples/a/readme.md#readme-3)
            * [readme 4](test/samples/a/readme.md#readme-4)
        * [c 1](test/samples/a/c.md#c-1)
          * [c 2](test/samples/a/c.md#c-2)
          * [F](test/samples/a/d/f.md)
            * [f 2](test/samples/a/d/f.md#f-2)
        * [e 1](test/samples/a/e.md#e-1)
        * [README 1 for g](test/samples/a/g/README.md#readme-1-for-g)
          * [h 1](test/samples/a/g/h.md#h-1)
    END
    node = Mdtoc::Node.for_path(sample_path('a'))
    actual = node.headers.join("\n") + "\n"

    assert_equal(expected, actual)
  end

  def test_file
    expected = <<~END
      * [Title](test/samples/README.md#title)
        * [2](test/samples/README.md#2)
          * [3](test/samples/README.md#3)
        * [2](test/samples/README.md#2)
            * [4](test/samples/README.md#4)
        * [2](test/samples/README.md#2)
    END
    node = Mdtoc::Node.for_path(sample_path('README.md'))
    actual = node.headers.join("\n") + "\n"

    assert_equal(expected, actual)
  end

  private

  def sample_path(path)
    File.join('test/samples', path)
  end
end
