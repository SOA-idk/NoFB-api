# frozen_string_literal: true

require 'sequel'

module NoFB
  module Database
    # Object-Relational Mapper for Members
    class UsersNotifyOrm < Sequel::Model(:users_notify)
      def self.db_find_or_create(member_info)
        UsersNotifyOrm.strict_param_setting = false
        first(user_id: member_info[:user_id]) || insert(member_info)
      end
    end
  end
end
