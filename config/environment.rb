# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'figaro'
require 'sequel'

module NoFB
  # Configuration for the App
  class App < Roda
    plugin :environment
    
    # rubocop:disable Lint/ConstantDefinitionInBlock
    configure do
      # Environment variables setup
      Figaro.application = Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load
      def self.config() = Figaro.env

      configure :development, :test do
        ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      end

      # Database Setup
      DB = Sequel.connect(ENV['DATABASE_URL'])
      def self.DB() = DB # rubocop:disable Naming/MethodName
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock
  end
end
