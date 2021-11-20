# frozen_string_literal: true

folders = %w[infrastructure models]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
