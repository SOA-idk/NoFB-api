# frozen_string_literal: true

rack_env = ENV['RACK_ENV'] || 'not set'

puts "rack_env seem to be #{rack_env}"
