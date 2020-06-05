# frozen_string_literal: true

module Rbr
  # Wraps a Parser::AST::Node object and provides convenience methods
  class Node
    def initialize(ast_node)
      @ast_node = ast_node
    end

    def assignment?
      %i[lvasgn ivasgn cvasgn gvasgn casgn masgn].include? @ast_node.type
    end

    def const?
      :const == @ast_node.type
    end

    def literal?
      %i[int float str].include? @ast_node.type
    end

    def method_call?
      %i[send csend].include? @ast_node.type
    end

    def nil?
      @ast_node.nil? || !(@ast_node.is_a? Parser::AST::Node)
    end

    def str?
      %i[str dstr xstr].include? @ast_node.type
    end

    def children
      @ast_node.children
    end

    def pretty_print
      "#{@ast_node.loc.expression.line}: #{@ast_node.loc.expression.source}"
    end

    # Call the the proc, passing in this node and all children recursively. Return
    # true if any call evaluates to true.
    def any_child_matches?(match_proc, root = self)
      if root.respond_to?(:children)
        root.children.any? { |c| any_child_matches?(match_proc, c) }
      else
        match_proc.call(root)
      end
    end
  end
end
