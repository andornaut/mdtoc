# typed: true
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

  def test_headers_without_spaces
    parser = Mdtoc::Markdown::Parser.new(0, '/')
    sample = <<~END
      #title1
      ##title2
    END

    headers = parser.headers(sample.each_line)

    assert_equal(2, headers.size)
    assert_equal('title1', headers[0].instance_variable_get(:@label))
    assert_equal('title2', headers[1].instance_variable_get(:@label))
  end

  def test_setext_headers
    parser = Mdtoc::Markdown::Parser.new(0, '/')
    sample = <<~END
      Title 1
      =======
      Title 2
      -------
    END

    headers = parser.headers(sample.each_line)

    assert_equal(2, headers.size)
    assert_equal('Title 1', headers[0].instance_variable_get(:@label))
    assert_equal(0, headers[0].instance_variable_get(:@depth))
    assert_equal('Title 2', headers[1].instance_variable_get(:@label))
    assert_equal(1, headers[1].instance_variable_get(:@depth))
  end

  def test_skips_html_comments
    parser = Mdtoc::Markdown::Parser.new(0, '/')
    sample = <<~END
      <!--
      # commented
      -->
      # not commented
    END

    headers = parser.headers(sample.each_line)

    assert_equal(1, headers.size)
    assert_equal('not commented', headers[0].instance_variable_get(:@label))
  end
end
