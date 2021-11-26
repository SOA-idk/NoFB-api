# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class Posts
      def self.all
        rebuild_entity Database::PostsOrm.all
      end

      def self.find_user_name_group_id(user_name, group_id)
        rebuild_entity Database::PostsOrm.where(user_name: user_name, group_id: group_id)
      end

      def self.rebuild_entity(db_records)
        return nil unless db_records

        post_list = db_records.map(&:post_id)

        Entity::Posts.new(
          posts: Post.rebuild_many(db_records),
          size: db_records.count,
          post_list: post_list,
          group_id: db_records.first.group_id.to_s # all db_records.group_id should be the same
        )
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
