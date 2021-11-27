# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for groups
    class Group
      def self.db_find_or_create(entity)
        Database::GroupsOrm.find_or_create(entity)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Group.new(group_name: db_record.group_name,
                          group_id: db_record.group_id)
      end
    end
  end
end
