# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class Subscribes
      def self.find_id(user_id, group_id)
        rebuild_entity Database::SubscribesOrm.first(user_id: user_id, group_id: group_id)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Subscribes.new(
          user_id: db_record.post_id.to_s,
          word: db_record.word,
          group_id: db_record.group_id.to_s
        )
      end

      # :reek:NilCheck
      def self.db_update_or_create(entity)
        existing = find_id(entity.user_id, entity.group_id)

        if existing.nil?
          Database::SubscribesOrm.create(entity)
        else
          existing.word = entity.word
          Database::SubscribesOrm.update(existing)
        end
      end
    end
  end
end
