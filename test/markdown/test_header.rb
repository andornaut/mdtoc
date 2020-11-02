# typed: false
# frozen_string_literal: true

require 'minitest/autorun'
require 'mdtoc/markdown/header'

class TestMarkdownHeader < Minitest::Test
  def test_fragment_normalization
    sample = [
      'Spaces 1 space',
      'Spaces  2 spaces',
      "Spaces\t1 tab",
      "Spaces\t\t2 tabs",
      '    Spaces leading and trailing    ',
      'Symbols _-=~!@#$%^&*()+<>?:"{}|[]\;\',./',
      'Alphabet 123 abc DEF Ghi',
    ]
    expecteds = [
      '/a#spaces-1-space',
      '/a#spaces--2-spaces',
      '/a#spaces1-tab',
      '/a#spaces2-tabs',
      '/a#spaces-leading-and-trailing',
      '/a#symbols-_-',
      '/a#alphabet-123-abc-def-ghi',
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
      '  strip  ',
      "squeeze    internal \t spaces",
      'Don\'t change "#1?|!@#$%^&*()+ 2--',
    ]
    expecteds = [
      'strip',
      "squeeze internal spaces",
      'Don\'t change "#1?|!@#$%^&*()+ 2--',
    ]
    actuals = sample.map { |label| Mdtoc::Markdown::Header.new(0, label, '/a').instance_variable_get(:@label) }

    expecteds.zip(actuals).each { |expected, actual| assert_equal(expected, actual) }
  end

  def test_to_s_prefix
    str = Mdtoc::Markdown::Header.new(3, 'a', '/a').to_s

    assert_equal('      * [a](/a)', str)
  end

  def test_to_s_with_fragment
    str = Mdtoc::Markdown::HeaderWithFragment.new(0, 'a', '/a').to_s

    assert_equal('* [a](/a#a)', str)
  end
end
