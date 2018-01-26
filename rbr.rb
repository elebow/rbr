require "parser/current"

#Dirty POC of a semantically-aware code search tool for Ruby
#Usage:
# search the file test/book.rb for statements that assign to the lvalue @author
#   ruby rbr.rb assignment @author test/book.rb

#TODO https://www.justinweiss.com/articles/3-ways-to-monkey-patch-without-making-a-mess/
module Parser
  module AST
    class Node
      def assignment?
        %i[lvasgn ivasgn cvasgn gvasgn casgn masgn].include? type
      end
    end
  end
end

def find_nodes(node:, name:, node_matcher:)
  return [] unless node.is_a? Parser::AST::Node

  found_children = node.children.map do |child|
    find_nodes(node: child,
               name: name,
               node_matcher: ->(cur_node, n) { node_matcher.call(cur_node, n) })
  end
  this_node = node_matcher.call(node, name) ? [node] : []

  this_node + found_children.flatten
end

def assignment_matcher(node, name)
  node.assignment? && node.children.first == name
end

matchers = {
  "assignment" => method(:assignment_matcher)
}

root = Parser::CurrentRuby.parse(File.read(ARGV[2]))
nodes = find_nodes(node: root,
                   name: ARGV[1].to_sym,
                   node_matcher: ->(cur_node, name) { matchers[ARGV[0]].call(cur_node, name) })
nodes.each do |node|
  puts "#{node.loc.expression.line}: #{node.loc.expression.source}"
end
