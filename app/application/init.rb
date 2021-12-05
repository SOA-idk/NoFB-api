# frozen_string_literal: true

%w[controllers requests services].each do |folder|
  require_relative "#{folder}/init.rb"
end
