# frozen_string_literal: true

%w[entities mappers repositories values]
  .each do |folder|
    Dir.glob("#{__dir__}/#{folder}/**/*.rb").each do |ruby_file|
      require_relative ruby_file
    end
  end
