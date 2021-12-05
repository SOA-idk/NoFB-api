# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class Group
      def self.all
        rebuild_entities Database::GroupsOrm.all
      end

      def self.find_id(group_id)
        rebuild_entity Database::GroupsOrm.first(group_id: group_id)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Group.new(
          group_id: db_record.group_id,
          group_name: db_record.group_name,
          updated_at: db_record.updated_at,
          created_at: db_record.created_at
        )
      end

      def self.rebuild_entities(db_records)
        return nil unless db_records

        db_records.map do |db_record|
          rebuild_entity db_record
        end
      end
    end
  end
end
