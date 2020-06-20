# Rbr

Rbr is a code search tool that parses Ruby code so you can query over certain semantic
constructs.

## Usage examples

assignment to an lvalue named `@author`

```sh
$ rbr assignment :@author test/fixtures/book.rb
test/fixtures/book.rb:5: @author = author
```

int or float with value `5`

```sh
$ rbr number 5 test/fixtures/book.rb
test/fixtures/book.rb:12: 5
```

string matching the pattern `/ring/`

```sh
$ rbr string ring test/fixtures/book.rb
test/fixtures/book.rb:13: "a string!"
```

literal (int, float, or string) with the value `5`

```sh
$ rbr literal 5 test/fixtures/book.rb
test/fixtures/book.rb:12: 5
test/fixtures/book.rb:49: "5"
```

comment matching the pattern `/great/`

```sh
$ rbr comment great test/fixtures/book.rb
test/fixtures/book.rb:1: # This is a great class
```

call of a method named `great_method`

```sh
$ rbr method_call :great_method test/fixtures/book.rb
test/fixtures/book.rb:27: book.great_method
test/fixtures/book.rb:50: book.send(:great_method)
```

statement that updates an ActiveRecord model attribute named `title`

```sh
$ rbr ar_update :title test/fixtures/book.rb
test/fixtures/book.rb:21: book.title = "Great Title"
test/fixtures/book.rb:27: book.update!(title: "Great Title")
test/fixtures/book.rb:31: book.send(:update_column, :title, "Great Title")
```

rbr is the wrong tool for the following situations:

appearance of the string "author" in the source

```sh
$ grep "author"
```

symbol named :author

```sh
$ grep ":author"
```

definition of any function named "publish"

```sh
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
