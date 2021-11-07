# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:groups) do
      primary_key :group_id

      String      :group_id, unique: true, null: false
      String      :group_name, unique: true, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
