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
    end
  end
end
