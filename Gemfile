# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'bootstrap',           '~> 4.3.1'
gem 'coffee-rails',        '~> 4.2'
gem 'devise',              '~> 4.7.1'
gem 'font_awesome5_rails', '~> 0.9.0'
gem 'jbuilder',            '~> 2.5'
gem 'jquery-rails',        '~> 4.3.5'
gem 'jquery-ui-rails'
gem 'pg',                  '>= 0.18', '< 2.0'
gem 'popper_js',           '~> 1.14.5'
gem 'puma',                '~> 3.12'
gem 'rails',               '~> 5.2.3'
gem 'redis',               '3.3.1'
gem 'rubocop',             '~> 0.76.0', require: false
gem 'sass-rails',          '~> 5.0'
gem 'simple_form',         '~> 5.0.1'
gem 'turbolinks',          '~> 5'
gem 'uglifier',            '>= 1.3.0'
gem 'will_paginate',       '~> 3.2.1'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'guard-rspec', require: false
  gem 'rspec-rails', '~> 3.9.0'
  gem 'rspec_junit_formatter'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'selenium-webdriver'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
