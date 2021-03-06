# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:posts) do
      String :post_id, unique: true # , null: false
      foreign_key :group_id, :groups, type: String
      String :user_name

      String :message

      String :updated_time

      primary_key [:post_id]
    end
  end
end
