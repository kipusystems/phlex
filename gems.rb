# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem "rubocop"
gem "zeitwerk"
gem "benchmark-ips"
gem "erb"
gem "ruby-lsp"

git "https://github.com/kipusystems/ruby_test_suite", branch: "main" do
  gem "sus"
end

group :test do
	gem "i18n"
	gem "memory_profiler"
end
