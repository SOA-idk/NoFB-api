# frozen_string_literal: true

# require 'pry'

# require_relative 'lib/init'

%w[config app].each do |folder|
  require_relative "#{folder}/init"
end
