# frozen_string_literal: true

require "rbr/matchers"
require "rbr/node"

module Rbr
  class Query
    attr_reader :matcher, :condition

    def initialize(matcher, condition)
      @matcher = matcher
      @condition = condition

      if matcher == :comment
        alias run run_comments
      else
        alias run run_tree
        @condition = condition.to_sym
      end
    end

    def run_comments(_node, comments)
      comments.select { |comment| comment.text.match?(condition) }
    end

    def run_tree(node, _comments = [])
      node = Node.new(node) unless node.is_a?(Node)
      return [] if node.nil?

      node_matches = Matchers.match(node, matcher, condition)
      found_children = node.children.map { |child| run(child) }

      (node_matches ? [node] : []) + found_children.flatten
    end
  end
end
