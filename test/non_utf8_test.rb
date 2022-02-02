# frozen_string_literal: true

require_relative "test_helper"
require_relative "../lib/rbr/cli"

class TestNonUTF8 < Minitest::Test
  def test_no_exception
    ARGV[0] = "string"
    ARGV[1] = "ggg"

    Rbr::CLI.new.start
  end
end
