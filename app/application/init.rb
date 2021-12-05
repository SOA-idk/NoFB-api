# frozen_string_literal: true

%w[controllers forms services representers].each do |folder|
  require_relative "#{folder}/init.rb"
end
