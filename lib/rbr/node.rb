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
      @ast_node.type == :const
    end

    def literal?
      %i[int float str].include? @ast_node.type
    end

    def number?
      %i[int float].include? @ast_node.type
    end

    def method_call?(names)
      %i[send csend].include?(@ast_node.type) &&
        begin
          names = [names] unless names.is_a?(Array)

          names.include?(children[1]) ||
            (children[1] == :send && names.include?(children[2].value))
        end
    end

    def nil?
      @ast_node.nil? || !(@ast_node.is_a? Parser::AST::Node)
    end

    def str?
      %i[str dstr xstr].include? @ast_node.type
    end

    def type
      @ast_node.type
    end

    def expression
      @ast_node.loc.expression
    end

    def children
      @ast_node.children.map do |child|
        if child.is_a?(Parser::AST::Node)
          Rbr::Node.new(child)
        else
          child
        end
      end
    end

    def value
      @ast_node.children[0]
    end

    def pretty_print
      "#{expression.line}: #{expression.source}"
    end

    # Call the the proc, passing in this node and all children recursively. Return
    # true if any call evaluates to true.
    def any_descendant_matches?(match_proc, root = self)
      if root.respond_to?(:children)
        root.children.any? { |c| any_descendant_matches?(match_proc, c) }
      else
        match_proc.call(root)
      end
    end
  end
end
