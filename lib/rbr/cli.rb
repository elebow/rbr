#!/usr/bin/env ruby

# frozen_string_literal: true

require "parser/current"
require "rbr/query"

# A semantically-aware code search tool for Ruby

module Rbr
  class CLI
    def self.start
      return unless check_arg_count

      matcher = ARGV[0].to_sym
      name = ARGV[1].to_sym
      root, comments = Parser::CurrentRuby.parse_file_with_comments(ARGV[2])

      nodes = Query.new(matcher => { name: name }).run(root)

      nodes.each do |node|
        puts node.pretty_print
      end
    end

    def self.check_arg_count
      return true if ARGV.count >= 3

      warn <<~USAGE
        Usage:
          rbr MATCHER PATTERN FILE

        Examples:
          # find assignments to lvalue :@author in the file test/book.rb
          rbr assignment @author test/book.rb

          # find strings matching /Author.*name/ in the file test/book.rb
          rbr str "Author.*name" test/book.rb
      USAGE

      false
    end
  end
end
