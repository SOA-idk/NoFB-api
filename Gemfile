# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# CONFIGURATION
gem 'figaro', '~> 1.2'
gem 'rack-test' # for testing and can also be used to diagnose in production
gem 'rake', '~> 13.0'

# PRESENTATION LAYER
gem 'multi_json', '~> 1.15'
gem 'roar', '~> 1.1'

# APPLICATION LAYER
# Web Application
gem 'puma', '~> 5.5'
gem 'roda', '~> 3.49'
gem 'rack', '~> 2' # 2.3 will fix delegateclass bug
# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# DOMAIN LAYER
# Validation
gem 'dry-struct', '~> 1.4'
gem 'dry-types', '~> 1.5'
# Value
gem 'watir', '~> 7.0'
gem 'webdrivers', '~> 5.0', require: false
gem 'date'
gem 'rest-client'

# INFRASTRUCTURE LAYER
# Networking
gem 'http', '~> 5.0'
# Database
gem 'hirb', '~> 0'
gem 'hirb-unicode', '~> 0'
gem 'sequel', '~> 5.49'
gem 'database_cleaner'
# Asynchronicity
gem 'concurrent-ruby', '~> 1.1'
gem 'aws-sdk-sqs', '~> 1.48'
gem 'shoryuken', '~> 5.3'


group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

group :production do
  gem 'pg', '~> 1.2'
end

# TESTING
group :test do
  gem 'minitest', '~> 5.0'
  gem 'minitest-rg', '~> 5.0'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6.0'
  gem 'webmock', '~> 3.0'

  gem 'page-object', '~> 2.3'
  # have included in DOMAIN Value
  # gem 'watir', '~> 7.0'
  # gem 'webdrivers', '~> 5.0'
  # gem 'headless', '~> 2.3'
end

group :development do
  gem 'rerun', '~> 0'
end

# DEBUGGING
gem 'pry'

# QUALITY
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end
