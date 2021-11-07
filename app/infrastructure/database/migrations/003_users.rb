# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      String      :user_id,  unique: true#, null: false
      String      :user_email
      String      :access_token

      primary_key [:user_id]
    end
  end
end
