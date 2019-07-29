require "parser/current"
require "matchers"
require "node"

#A semantically-aware code search tool for Ruby
#Usage:
# search the file test/book.rb for statements that assign to the lvalue @author
#   ruby -I . rbr.rb assignment @author test/book.rb

def find_nodes(ast_node, query)
  node = Node.new(ast_node)
  return [] if node.nil?

  node_matches = Matchers.match(node, query)
  found_children = node.children.map { |child| find_nodes(child, query) }

  (node_matches ? [node] : []) + found_children.flatten
end

matcher = ARGV[0].to_sym
name = ARGV[1].to_sym
root = Parser::CurrentRuby.parse_file(ARGV[2])

nodes = find_nodes(root, matcher => { name: name })

nodes.each do |node|
  puts node.pretty_print
end
