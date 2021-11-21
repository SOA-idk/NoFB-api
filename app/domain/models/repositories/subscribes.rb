# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class Subscribes
      def self.find_all(user_id)
        rebuild_entities Database::SubscribesOrm.where(user_id: user_id).all
      end

      def self.find_id(user_id, group_id)
        rebuild_entity Database::SubscribesOrm.first(user_id: user_id, group_id: group_id)
      end

      # single record
      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Subscribes.new(
          user_id: db_record.user_id.to_s,
          word: db_record.word,
          group_id: db_record.group_id.to_s
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
        existing = find_id(entity.user_id, entity.group_id)
        if existing.nil?
          Database::SubscribesOrm.create(entity)
        else
          # update word
          update_info = Entity::Subscribes.new(user_id: existing.user_id.to_s, word: entity.word,
                                               group_id: existing.group_id.to_s)
          Database::SubscribesOrm.update(update_info)
        end
      end
    end
  end
end
