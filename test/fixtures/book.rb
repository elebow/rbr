# Book class
class Book
  def initialize(title:, author:)
    @title = title
    @author = author
  end

  def pretty_print
    "#{@title} by #{author}"
  end

  5
  "a string!"
  Math.PI
  Math
  class Hamburger; end

  def ar_update
    book = Book.new

    book.title = "Great Title"
    book.attributes = { title: "Great Title" }
    book.assign_attributes(title: "Great Title")
    book.write_attribute(:title, "Great Title")
    book[:title] = "Great Title"
    book.update(title: "Great Title")
    book.update!(title: "Great Title")
    book.update_attribute(:title, "Great Title")
    book.update_attributes(title: "Great Title")
    book.update_attributes!(title: "Great Title")
    book.update_column(:title, "Great Title")
    book.update_columns(title: "Great Title")
    Book.update(5, title: "Great Title")
    Book.update_all(title: "Great Title")
    Book.upsert(title: "Great Title")
    Book.upsert_all(title: "Great Title")
    Book.insert(title: "Great Title")
    Book.insert!(title: "Great Title")
    Book.insert_all(title: "Great Title")
    Book.insert_all!(title: "Great Title")

    book.update(title: "Great Title", author: "Some Author")
    update(title: "Great Title", author: "Some Author")

    book.title
    book.update(author: "Some Author")
  end

  "5"
  book.send(:update!, title: "Great Title")
end
