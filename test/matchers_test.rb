# frozen_string_literal: true

require "parser/current"
require_relative "test_helper"

class TestMatchers < Minitest::Test
  def setup
    @ast_root, @comments =
      Parser::CurrentRuby.parse_file_with_comments("test/fixtures/book.rb")
  end

  def test_assignment
    assert_query_matches(
      { assignment: { name: :@author } },
      ["5: @author = author"]
    )
  end

  def test_is
    assert_query_matches(
      { is: { name: :"5" } },
      ["12: 5"]
    )
  end

  def test_const
    assert_query_matches(
      { const: { name: :Math } },
      ["14: Math",
       "15: Math"]
    )
  end

  def test_str
    assert_query_matches(
      { str: { pattern: "ring" } },
      ["13: \"a string!\""]
    )
  end

=begin
  def test_comment
    assert_query_matches(
      { comment: { name: :Math } },
      ["13: Math",
       "14: Math"]
    )
  end
=end
end
