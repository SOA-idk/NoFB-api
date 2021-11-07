# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class Post
      def self.find_id(post_id)
        rebuild_entity Database::PostsOrm.first(post_id: post_id)
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
        user = Entity::User.new(
          user_id: '123',
          user_email: 'abc@gmail.com',
          access_token: "Idon'tcare"
        )
        Database::UsersOrm.find_or_create(user.to_attr_hash)

        group = Entity::Group.new(
          group_id: entity.group_id,
          group_name: 'lalalala',
        )
        Database::GroupsOrm.find_or_create(group.to_attr_hash)
        Database::PostsOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
