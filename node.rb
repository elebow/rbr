# Wraps a Parser::AST::Node object and provides convenience methods
class Node
  def initialize(ast_node)
    @ast_node = ast_node
  end

  def assignment?
    %i[lvasgn ivasgn cvasgn gvasgn casgn masgn].include? @ast_node.type
  end

  def nil?
    @ast_node.nil? || !(@ast_node.is_a? Parser::AST::Node)
  end

  def children
    @ast_node.children
  end

  def pretty_print
    "#{@ast_node.loc.expression.line}: #{@ast_node.loc.expression.source}"
  end
end
