# frozen_string_literal: true

require 'sequel'

module NoFB
  module Database
    # Object Relational Mapper for Project Entities
    class SubscribesOrm < Sequel::Model(:subscribes)
      plugin :timestamps, update_on_create: true

      def self.create(member_info)
        SubscribesOrm.strict_param_setting = false
        insert(member_info)
      end

      def self.update(member_info)
        SubscribesOrm.strict_param_setting = false
        where(user_id: member_info[:user_id], group_id: member_info[:group_id]).update(word: member_info.word)
      end
    end
  end
end
