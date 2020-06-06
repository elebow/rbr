# frozen_string_literal: true

module Rbr
  # methods for determining if a node matches given conditions
  class Matchers
    def self.match(node, query)
      query.map do |matcher, condition|
        send(matcher, node, condition)
      end.all?  #TODO any? or all?
    end

    # Updating an ActiveRecord model attribute
    def self.ar_update(node, name)
      attribute_name = name
      matches = if attribute_name
                  node.children.first == attribute_name
                else
                  true # everything matches if no condition
                end

      node.method_call? &&
        node.children[1] == :update &&
        node.children[1].is_a_hash_containing_node(children: [:name])
    end

    # Assignment to a specified lvalue
    def self.assignment(node, name)
      return false unless node.assignment? && name

      node.children.first == name
    end

    # Node is a literal int, float, or string
    # TODO rename. Literal?
    def self.is(node, value)
      return false unless node.literal? && value

      # Ruby symbols can't start with a number, so #to_s first
      node.children.first.to_s.to_sym == value
    end

    # Node is a Ruby constant
    def self.const(node, name)
      return false unless node.const? && name

      node.children.last == name
    end

    # Node is a string
    def self.str(node, pattern)
      return false unless node.str? && pattern

      node.any_child_matches?(
        ->(n) { n.is_a?(String) && n.match?(pattern) }
      )
    end

    # Node is a comment
    def self.comment(node, conds)
      return false unless node.comment?

      #TODO
    end

    # Anything other than a string
    def self.not_str(node, pattern)
      return false if node.str?

      return false unless pattern

      #TODO
      node.any_child_matches?(
        ->(n) { n.is_a?(String) && n.match?(pattern) }
      )
    end
  end
end
