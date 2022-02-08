# Rbr

Rbr is a code search tool that parses Ruby code so you can query over certain semantic constructs.

This differs from a file contents search (like grep) in that rbr understands Ruby grammar. This allows you to search your codebase for, say, every place that a method is called without matching the method definition or other occurrences of the method name.

## Usage examples

- Find all assignments to an lvalue named `@author`, but not any other references to that variable.

    ```sh
    $ rbr assignment :@author test/fixtures/book.rb
    test/fixtures/book.rb:5: @author = author
    ```

- Find any int or float with value `5`, but not any strings or comments that contain 5.

    ```sh
    $ rbr number 5 test/fixtures/book.rb
    test/fixtures/book.rb:12: 5
    ```

- Find all strings matching the pattern `/ring/`.

    ```sh
    $ rbr string ring test/fixtures/book.rb
    test/fixtures/book.rb:13: "a string!"
    ```

- Find all literals (int, float, or string) with the value `5`.

    ```sh
    $ rbr literal 5 test/fixtures/book.rb
    test/fixtures/book.rb:12: 5
    test/fixtures/book.rb:49: "5"
    ```

- Find all comments matching the pattern `/great/`, but not any uncommented Ruby code.

    ```sh
    $ rbr comment great test/fixtures/book.rb
    test/fixtures/book.rb:1: # This is a great class
    ```

- Find all calls of a method named `great_method`, but not the definition or any other appearances of that identifier.

    ```sh
    $ rbr method_call :great_method test/fixtures/book.rb
    test/fixtures/book.rb:27: book.great_method
    test/fixtures/book.rb:50: book.send(:great_method)
    ```

- Find statements that update an ActiveRecord model attribute named `title`.

    ```sh
    $ rbr ar_update :title test/fixtures/book.rb
    test/fixtures/book.rb:21: book.title = "Great Title"
    test/fixtures/book.rb:27: book.update!(title: "Great Title")
    test/fixtures/book.rb:31: book.send(:update_column, :title, "Great Title")
    ```

    Note that this matcher is necessarily incomplete. For example, a parser alone cannot find situations like the following.

    ```ruby
    def update_record(attrs)
      record.update(attrs)
    end

    update_record(title: "Great Author")
    ```

### rbr is the *wrong tool* for the following situations:

- Find all appearance of "author" in a codebase.

    ```sh
    $ grep "author"
    ```

- Find all occurrences of the symbol `:author`. Symbols are easy to match in Ruby syntax, so you can use grep.

    ```sh
    $ grep ":author\b"
    ```

- Find the definition of any function named `publish`. Definitions are easy to match in Ruby syntax, so you can use grep.

    ```sh
    $ grep "def publish\b"
    ```

## Installation

Rbr is intended to be used as a command-line program. Install the executable `rbr` with:

```
gem install rbr
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests or `bundle exec rbr` to run the local copy.

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
