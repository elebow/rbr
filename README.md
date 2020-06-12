# Rbr

Rbr is a code search tool that parses Ruby code so you can query over certain semantic
constructs.

## Usage examples

```sh
# assignment to an lvalue named `@author`
$ rbr assignment :@author test/fixtures/book.rb
5: @author = author

# int or float
$ rbr number 5 test/fixtures/book.rb
12: 5

# string
$ rbr string ring test/fixtures/book.rb
13: "a string!"

# a literal (int, float, or string)
$ rbr literal 5 test/fixtures/book.rb
12: 5
49: "5"

# comments matching the pattern /great/
$ rbr comment great test/fixtures/book.rb
1: # This is a great class

# find all calls of a method named `great_method`
$ rbr method_call :great_method test/fixtures/book.rb
27: book.update!(title: "Great Title")
50: book.send(:update!, title: "Great Title")

# statements that update an ActiveRecord model attribute named `title`
$ rbr ar_update :title test/fixtures/book.rb
21: book.title = "Great Title"
27: book.update!(title: "Great Title")
31: book.update_column(:title, "Great Title")
```

rbr is the wrong tool for the following situations:

```sh
# find any appearance of the string "author" in the source
$ grep "author"

# find a symbol named :author
$ grep ":author"

# find the definition of any function named "publish"
$ grep "def publish"
```

## Installation

Rbr is intended to be used as a command-line program. Install the executable `rbr`
with:

```
gem install rbr
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then,
run `rake test` to run the tests or `bundle exec rbr` to run the local copy.
