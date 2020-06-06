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
      return false unless name && node.method_call?

      ar_update_hash(node, name) ||
        ar_update_positional(node, name) ||
        ar_update_dynamic_method(node, name) ||
        ar_update_attributes(node, name) ||
        ar_update_hash_element(node, name)
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

    private

    private_class_method def self.ar_update_hash(node, name)
      return false unless %i[update update! assign_attributes update_attributes
                             update_attributes! update_columns update_all upsert
                             upsert_all insert insert! insert_all insert_all!]
                          .include?(node.children[1])

      hash_arg = if node.children[3]&.type == :hash
                   node.children[3]
                 else
                   node.children[2]
                 end

      hash_arg.children.any? { |child| child.children[0].children[0] == name }
    end

    private_class_method def self.ar_update_positional(node, name)
      return false unless  %i[write_attribute update_attribute update_column]
                           .include?(node.children[1])

      node.children[2].children[0] == name
    end

    private_class_method def self.ar_update_dynamic_method(node, name)
      node.children[1] == "#{name}=".to_sym
    end

    private_class_method def self.ar_update_attributes(node, name)
      node.children[1] == :attributes= &&
      node.children[2].children.any? do |child|
        child.children[0].children[0] == name
      end
    end

    private_class_method def self.ar_update_hash_element(node, name)
      node.children[1] == :[]= && node.children[2].children[0] == name
    end
  end
end
