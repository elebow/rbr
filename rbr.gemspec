# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rbr/version"

Gem::Specification.new do |spec|
  spec.name = "rbr"
  spec.version = Rbr::VERSION
  spec.authors = ["Eddie Lebow"]
  spec.email = ["elebow@users.noreply.github.com"]
  spec.license = "GPL-3.0-or-later"

  spec.summary = "Semantically-aware code search tool for Ruby"
  #spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "https://github.com/elebow/rbr"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/elebow/rbr"
  spec.metadata["changelog_uri"] = "https://github.com/elebow/rbr/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.6.0"

  spec.add_dependency "parser"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
