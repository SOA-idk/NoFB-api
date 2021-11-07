# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String      :user_id,  unique: true, null: false
      String      :user_email
      String      :access_token
    end
  end
end
