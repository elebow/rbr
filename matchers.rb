# methods for determining if a node matches given conditions
class Matchers
  def self.match(node, query)
    query.map do |matcher, conds|
      send(matcher, node, conds)
    end.all?  #TODO any? or all?
  end

  # Assignment to a specified lvalue
  def self.assignment(node, conds)
    lvalue_matches = if conds[:name]
                       node.children.first == conds[:name]
                     else
                       true # everything matches if no condition
                     end

    node.assignment? && lvalue_matches
  end

  # Node is a literal int, float, or string
  def self.is(node, conds)
    value_matches = if conds[:name]
                      # Ruby symbols can't start with a number, so #to_s first
                      node.children.first.to_s.to_sym == conds[:name]
                    else
                      true # everything matches if no condition
                    end

    node.literal? && value_matches
  end
end
