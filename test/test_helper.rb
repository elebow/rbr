# frozen_string_literal: true

require "minitest/autorun"
require "pry"

require "rbr/query"

def run_query(matcher, condition)
  Rbr::Query.new(matcher, condition).run(@ast_root, @comments)
end

def assert_query_matches(matcher, condition, matches)
  assert_equal(
    run_query(matcher, condition).map(&:pretty_print),
    matches
  )
end
