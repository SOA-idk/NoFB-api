# frozen_string_literal: true

require 'database_cleaner'

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    NoFB::App.DB.run('PRAGMA foreign_keys = OFF')
    NoFB::Database::Post.map(&:destroy)
    NoFB::Database::Posts.map(&:destroy)
    NoFB::App.DB.run('PRAGMA foreign_keys = ON')
  end
end