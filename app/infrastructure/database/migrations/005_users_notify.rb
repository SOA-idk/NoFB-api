# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:users_notify) do
      foreign_key :user_id, :users, type: String
      String :user_access_token
    end
  end
end
