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
      :assignment,
      :@author,
      ["5: @author = author"]
    )
  end

  def test_literal
    assert_query_matches(
      :literal,
      :"5",
      ["12: 5", "33: 5", "49: \"5\""]
    )
  end

  def test_number
    assert_query_matches(
      :number,
      :"5",
      ["12: 5", "33: 5"]
    )
  end

  def test_const
    assert_query_matches(
      :const,
      :Math,
      ["14: Math",
       "15: Math"]
    )
  end

  def test_str
    assert_query_matches(
      :str,
      "ring",
      ["13: \"a string!\""]
    )
  end

  def test_ar_update
    assert_query_matches(
      :ar_update,
      :title,
      ['21: book.title = "Great Title"',
       '22: book.attributes = { title: "Great Title" }',
       '23: book.assign_attributes(title: "Great Title")',
       '24: book.write_attribute(:title, "Great Title")',
       '25: book[:title] = "Great Title"',
       '26: book.update(title: "Great Title")',
       '27: book.update!(title: "Great Title")',
       '28: book.update_attribute(:title, "Great Title")',
       '29: book.update_attributes(title: "Great Title")',
       '30: book.update_attributes!(title: "Great Title")',
       '31: book.update_column(:title, "Great Title")',
       '32: book.update_columns(title: "Great Title")',
       '33: Book.update(5, title: "Great Title")',
       '34: Book.update_all(title: "Great Title")',
       '35: Book.upsert(title: "Great Title")',
       '36: Book.upsert_all(title: "Great Title")',
       '37: Book.insert(title: "Great Title")',
       '38: Book.insert!(title: "Great Title")',
       '39: Book.insert_all(title: "Great Title")',
       '40: Book.insert_all!(title: "Great Title")',
       '42: book.update(title: "Great Title", author: "Some Author")',
       '43: update(title: "Great Title", author: "Some Author")']
    )
  end

=begin
  #TODO
  def test_comment
    assert_query_matches(
      { comment: { name: :Math } },
      ["13: Math",
       "14: Math"]
    )
  end
=end
end
