#!/usr/bin/env ruby

# frozen_string_literal: true

require "find"
require "parser/current"

require "rbr/query"

module Rbr
  class CLI
    def self.start
      return unless check_arg_count

      matcher = ARGV[0].to_sym
      condition = ARGV[1]

      filenames.each do |filename|
        root, comments = Parser::CurrentRuby.parse_file_with_comments(filename)

        matching_nodes = Query.new(matcher, condition).run(root, comments)

        matching_nodes.each { |node| puts node.pretty_print }
      end
    end

    def self.filenames
      ARGV[2..].map { |arg| Find.find(arg).to_a }
               .flatten
               .select { |filename| File.file?(filename) }
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
