# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class Posts
      def self.all
        rebuild_entities Database::PostsOrm.all
      end

      def self.find_group_id(group_id)
        rebuild_entity Database::PostsOrm.where(group_id: group_id)
      end

      def self.rebuild_entity(db_records)
        return nil unless db_records

        post_list = db_records.map(&:post_id)
        return nil if post_list.empty?

        group = NoFB::Repository::Group.find_id(db_records.first.group_id.to_s)
        Entity::Posts.new(
          posts: Post.rebuild_many(db_records),
          size: db_records.count,
          post_list: post_list,
          group_id: db_records.first.group_id.to_s, # all db_records.group_id should be the same
          group_name: group.group_name
        )
      end

      def self.rebuild_entities(db_records)
        return nil unless db_records

        result = db_records.map do |db_record|
          Entity::Post.new(
            post_id: db_record.post_id,
            group_id: db_record.group_id,
            user_name: db_record.user_name,
            message: db_record.message,
            updated_time: db_record.updated_time
          )
        end

        result
      end

      def self.find(entity)
        find_origin_id(entity.origin_id)
      end

      def self.create(entity)
        entity.posts.each do |post|
          NoFB::Repository::Post.db_find_or_create(post, group_name)
        end
      end
    end
  end
end
