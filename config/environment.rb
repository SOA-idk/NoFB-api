# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'figaro'
require 'sequel'
require 'delegate' # flash due to bug in rack < 2.3.0

module NoFB
  # Configuration for the App
  class App < Roda
    plugin :environments

    # rubocop:disable Lint/ConstantDefinitionInBlock
    configure do
      # Environment variables setup
      Figaro.application = Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load
      def self.config() = Figaro.env

      use Rack::Session::Cookie, secrets: config.SESSION_SECRET

      configure :development, :test do
        ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      end

      ENV['FB_USERNAME'] = config.FB_USERNAME
      ENV['FB_PASSWORD'] = config.FB_PASSWORD
      # Database Setup
      DB = Sequel.connect(ENV['DATABASE_URL'])
      # rubocop:disable Naming/MethodName
      # :reek:UncommunicativeMethodName
      def self.DB() = DB
      # rubocop:enable Naming/MethodName
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock
  end
end
