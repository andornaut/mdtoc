# typed: false
# frozen_string_literal: true

require "minitest/autorun"
require "mdtoc/markdown"

class TestHeader < Minitest::Test
  def test_fragment_normalization
    sample = [
      'C__D--d f',
      "##1?|!@#$%^&*()+\t\t2 -",
    ]
    expecteds = [
      '/a#c__d--d-f',
      '/a#1-2--',
    ]
    actuals = sample.map do |label|
      Mdtoc::Markdown::HeaderWithFragment.new(1, label, '/a').instance_variable_get(:@url)
    end

    expecteds.zip(actuals).each { |expected, actual| assert_equal(expected, actual) }
  end

  def test_invalid_depth
    assert_raises(ArgumentError) do
      Mdtoc::Markdown::Header.new(-1, 'a', '/a')
    end
  end

  def test_label_normalization
    sample = [
      ' capitalize and strip spaces and ___ underscores',
      "squeeze internal \t\n\r spaces",
      'Don\'t change #1?|!@#$%^&*()+ 2--',
    ]
    expecteds = [
      'Capitalize and strip spaces and underscores',
      "Squeeze internal spaces",
      'Don\'t change #1?|!@#$%^&*()+ 2--',
    ]
    actuals = sample.map { |label| Mdtoc::Markdown::Header.new(0, label, '/a').instance_variable_get(:@label) }

    expecteds.zip(actuals).each { |expected, actual| assert_equal(expected, actual) }
  end

  def test_to_s_prefix
    str = Mdtoc::Markdown::Header.new(3, 'a', '/a').to_s

    assert_equal('      * [A](/a)', str)
  end

  def test_to_s_with_fragment
    str = Mdtoc::Markdown::HeaderWithFragment.new(0, 'a', '/a').to_s

    assert_equal('* [A](/a#a)', str)
  end

  def test_to_s_without_fragment
    str = Mdtoc::Markdown::Header.new(0, 'a', '/a').to_s

    assert_equal('* [A](/a)', str)
  end
end

class TestParser < Minitest::Test
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
    assert_equal('Title', headers[0].instance_variable_get(:@label))
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
