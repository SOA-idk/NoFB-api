# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class UsersNotify
      def self.all
        rebuild_entities Database::UsersNotifyOrm.all
      end

      def self.find_id(user_id)
        rebuild_entity Database::UsersNotifyOrm.first(user_id: user_id)
      end

      # single record
      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Notify.new(
          user_id: db_record.user_id,
          user_access_token: db_record.user_access_token
        )
      end

      def self.db_update(entity)
        existing = find_id(entity[:user_id])
        return nil unless existing

        Database::UsersNotifyOrm.update(existing)
      end

      def self.db_create(entity)
        Database::UsersNotifyOrm.find_or_create(entity)
      end
    end
  end
end
