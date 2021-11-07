# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:posts) do
      primary_key :id
      String :post_id,  unique: true, null: false
      foreign_key :group_id, :groups
      foreign_key :user_id, :users

      String      :message

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
