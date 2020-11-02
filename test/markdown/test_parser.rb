# typed: false
# frozen_string_literal: true

require 'minitest/autorun'
require 'mdtoc/markdown/parser'

class TestMarkdownParser < Minitest::Test
  def test_skips_multiline_code_blocks
    parser = Mdtoc::Markdown::Parser.new(0, '/')
    sample = <<~END
      # title
      ```
      code
      # code
      ```
    END

    headers = parser.headers(sample.each_line)

    assert_equal(1, headers.size)
    assert_equal('title', headers[0].instance_variable_get(:@label))
  end

  def test_skips_inline_code_blocks
    parser = Mdtoc::Markdown::Parser.new(0, '/')
    sample = <<~END
      ```code #```
      # Title
      ```# code```
      ```code```#
    END

    headers = parser.headers(sample.each_line)

    assert_equal(1, headers.size)
    assert_equal(headers[0].instance_variable_get(:@label), 'Title')
  end

  def test_depth
    parser = Mdtoc::Markdown::Parser.new(10, '/')
    sample = <<~END
      # 1
      ## 2
      ### 3
      #### 4
    END

    headers = parser.headers(sample.each_line)

    assert_equal(4, headers.size)
    (0..3).each do |i|
      assert_equal(10 + i, headers[i].instance_variable_get(:@depth))
    end
  end
end
