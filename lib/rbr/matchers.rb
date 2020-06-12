# frozen_string_literal: true

module Rbr
  # methods for determining if a node matches given conditions
  class Matchers
    def self.match(node, matcher, condition)
      send(matcher, node, condition)
    end

    # Method call
    def self.method_call(node, name)
      name &&
        node.method_call? &&
        node.children[1] == name
    end

    # Updating an ActiveRecord model attribute
    def self.ar_update(node, name)
      name &&
        node.method_call? &&
        (
          ar_update_hash(node, name) ||
          ar_update_positional(node, name) ||
          ar_update_dynamic_method(node, name) ||
          ar_update_attributes(node, name) ||
          ar_update_hash_element(node, name)
        )
    end

    # Assignment to a specified lvalue
    def self.assignment(node, name)
      name &&
        node.assignment? &&
        node.value == name
    end

    # Node is a literal int, float, or string
    def self.literal(node, value)
      number(node, value) || str(node, value)
    end

    # Node is a literal int or float
    def self.number(node, value)
      value &&
        node.number? &&
        node.value.to_s == value
    end

    # Node is a Ruby constant
    def self.const(node, name)
      name &&
        node.const? &&
        node.children.last == name
    end

    # Node is a string
    def self.str(node, pattern)
      pattern &&
        node.str? &&
        node.any_descendant_matches?(
          ->(n) { n.is_a?(String) && n.match?(pattern) }
        )
    end

    # Anything other than a string
    def self.not_str(node, pattern)
      return false if node.str?

      return false unless pattern

      #TODO
      node.any_descendant_matches?(
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

      hash_arg.children.any? { |child| child.children[0].value == name }
    end

    private_class_method def self.ar_update_positional(node, name)
      return false unless  %i[write_attribute update_attribute update_column]
                           .include?(node.children[1])

      node.children[2].value == name
    end

    private_class_method def self.ar_update_dynamic_method(node, name)
      node.children[1] == "#{name}=".to_sym
    end

    private_class_method def self.ar_update_attributes(node, name)
      node.children[1] == :attributes= &&
      node.children[2].children.any? do |child|
        child.children[0].value == name
      end
    end

    private_class_method def self.ar_update_hash_element(node, name)
      node.children[1] == :[]= && node.children[2].value == name
    end
  end
end
