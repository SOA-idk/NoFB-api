# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:subscribes) do
      foreign_key :user_id, :users
      foreign_key :group_id, :groups
      String      :word

      primary_key %i[user_id group_id]
    end
  end
end
