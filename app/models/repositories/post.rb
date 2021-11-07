# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class Post
      def self.find_id(id)
        rebuild_entity Database::PostsOrm.first(id: id)
      end

      def self.find_message(message)
        rebuild_entity Database::PostsOrm.first(message: message)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Post.new(
          post_id: db_record.post_id,
          updated_time: db_record.updated_time,
          message: db_record.message,
          user_id: db_record.user_id,
          group_id: db_record.group_id
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_post|
          Post.rebuild_entity(db_post)
        end
      end

      def self.db_find_or_create(entity)
        Database::PostsOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
