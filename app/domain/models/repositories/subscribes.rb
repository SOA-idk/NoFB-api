# frozen_string_literal: true

module NoFB
  module Repository
    # Repository for post
    class Subscribes
      def self.all
        rebuild_entities Database::SubscribesOrm.all
      end

      def self.find_all(input)
        rebuild_entities Database::SubscribesOrm.where(user_id: input[:user_id]).all
      end

      def self.find_id(user_id, group_id)
        rebuild_entity Database::SubscribesOrm.first(user_id: user_id, group_id: group_id)
      end

      def self.query(input)
        Database::SubscribesOrm[input]
      end

      def self.delete(input)
        Database::SubscribesOrm[input].delete
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

      def self.db_update(entity)
        existing = find_id(entity[:user_id], entity[:group_id])
        return nil unless existing

        # update word
        update_info = Entity::Subscribes.new(user_id: existing.user_id.to_s, word: entity[:word],
                                             group_id: existing.group_id.to_s)
        Database::SubscribesOrm.update(update_info)
      end
    end
  end
end
