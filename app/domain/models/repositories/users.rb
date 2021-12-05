# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class Users
      def self.all
        rebuild_entities Database::UsersOrm.all
      end

      def self.find_id(user_id)
        rebuild_entity Database::UsersOrm.first(user_id: user_id)
      end

      # single record
      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::User.new(
          user_id: db_record.user_id.to_s,
          user_email: db_record.user_email,
          user_name: db_record.user_name.to_s,
          user_img: db_record.user_img.to_s
        )
      end

      # many records
      def self.rebuild_entities(db_records)
        return nil unless db_records

        db_records.map do |db_record|
          rebuild_entity db_record
        end
      end

      # :reek:NilCheck
      def self.db_update_or_create(entity)
        existing = find_id(entity[:user_id])
        if existing.nil?
          Database::UsersOrm.create(entity)
        else
          # update user
          update_info = Entity::User.new(user_id: existing.user_id.to_s, user_email: entity.user_email.to_s,
                                         user_name: existing.user_name.to_s, user_img: existing.user_img.to_s)
          Database::UsersOrm.update(update_info)
        end
      end
    end
  end
end
