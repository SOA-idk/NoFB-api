# frozen_string_literal: true

require 'sequel'

module NoFB
  module Database
    # Object-Relational Mapper for Members
    class GroupsOrm < Sequel::Model(:groups)
      # a group could have many posts
      one_to_many :owned_posts,
                  class: :'NoFB::Database::PostsOrm',
                  key: :group_id

      # many_to_many :contributed_projects,
      #             class: :'NoFB::Database::PostsOrm',
      #             join_table: :projects_members,
      #            left_key: :member_id, right_key: :project_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(member_info)
        GroupsOrm.strict_param_setting = false
        first(group_id: member_info[:group_id]) || insert(member_info)
        puts GroupsOrm[group_id: member_info[:group_id]]
      end
    end
  end
end
