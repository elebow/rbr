# frozen_string_literal: true

require "rbr/matchers"
require "rbr/node"

module Rbr
  class Query
    attr_reader :conditions

    def initialize(conditions)
      @conditions = conditions
    end

    def run(node)
      node = Node.new(node) unless node.is_a?(Node)
      return [] if node.nil?

      node_matches = Matchers.match(node, conditions)
      found_children = node.children.map { |child| run(child) }

      (node_matches ? [node] : []) + found_children.flatten
    end
  end
end
