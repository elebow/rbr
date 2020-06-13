# frozen_string_literal: true

require "parser/current"

require "rbr/query"

module Rbr
  class CLI
    def initialize
      check_arg_count

      @matcher = ARGV[0].to_sym
      @condition = ARGV[1]
    end

    def start
      matching_nodes.each do |filename, nodes|
        nodes.each { |node| puts "#{filename}:#{node.pretty_print}" }
      end
    end

    def matching_nodes
      filenames.map do |filename|
        root, comments = Parser::CurrentRuby.parse_file_with_comments(filename)

        [filename, Query.new(@matcher, @condition).run(root, comments)]
      rescue EncodingError
        warn "# Encoding error parsing #{filename}"
        [filename, []]
      end.to_h
    end

    def filenames
      ARGV[2..].map { |arg| expand_path(arg) }
               .flatten
               .select { |filename| File.file?(filename) }
    end

    def expand_path(path)
      return [path] if File.file?(path)

      # if path is not a file, then glob all .rb files beneath it
      Dir.glob("#{path}/**/*.rb")
    end

    def check_arg_count
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
