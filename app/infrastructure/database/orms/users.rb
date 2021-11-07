# frozen_string_literal: true

require 'sequel'

module NoFB
  module Database
    # Object-Relational Mapper for Members
    class UsersOrm < Sequel::Model(:users)
      # a group could have many posts
      # one_to_many :owned_posts,
      #             class: :'NoFB::Database::PostsOrm',
      #             key: :group_id

      # many_to_many :contributed_projects,
      #             class: :'NoFB::Database::PostsOrm',
      #             join_table: :projects_members,
      #            left_key: :member_id, right_key: :project_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(member_info)
        UsersOrm.strict_param_setting = false
        # puts UsersOrm.columns
        # puts member_info
        # puts member_info[:user_id]
        # puts first(user_id: member_info[:user_id])
        # puts insert(member_info)
        first(user_id: member_info[:user_id]) || insert(member_info)
      end
    end
  end
end
