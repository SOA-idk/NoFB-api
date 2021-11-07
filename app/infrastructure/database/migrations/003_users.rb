# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :user_id
      String      :user_id
      String      :user_email
      String      :access_token
    end
  end
end
