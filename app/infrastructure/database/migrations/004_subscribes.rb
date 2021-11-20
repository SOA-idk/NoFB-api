# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:subscribes) do
      foreign_key :user_id, :users, type:String
      foreign_key :group_id, :groups, type:String
      String      :word

      primary_key [:user_id, :group_id]
    end
  end
end
