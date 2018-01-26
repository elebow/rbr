class Book
  def initialize(title:, author:)
    @title = title
    @author = author
  end

  def pretty_print
    "#{@title} by #{author}"
  end
end
