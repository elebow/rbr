# frozen_string_literal: true

require "minitest/autorun"
require "pry"

require "rbr/query"

def run_query(query)
  Rbr::Query.new(query).run(@ast_root)
end

def assert_query_matches(query, matches)
  assert_equal(
    run_query(query).map(&:pretty_print),
    matches
  )
end
