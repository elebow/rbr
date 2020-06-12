# frozen_string_literal: true

module Rbr
  # Wraps a Parser::Source::Comment object and provides convenience methods
  class CommentNode
    def initialize(parser_comment)
      @parser_comment = parser_comment
    end

    def expression
      @parser_comment.loc.expression
    end

    def pretty_print
      "#{expression.line}: #{@parser_comment.text}"
    end
  end
end
