# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class Posts
      def self.find_user_id_group_id(user_id, group_id)
        rebuild_entity Database::PostsOrm.all(user_id: user_id, group_id: group_id)
      end

      def self.rebuild_entity(db_records)
        return nil unless db_records

        post_list = db_records.map do |db_record|
          db_record.post_id
        end

        Entity::Posts.new(
          posts:         Post.rebuild_many(db_records),
          size:       db_records.length,
          post_list:  post_list,
          group_id:   db_records[0].group_id # all db_records.group_id should be the same
        )
      end
    end
  end
end