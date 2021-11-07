# frozen_string_literal: true

require 'sequel'

module NoFB
  module Database
    # Object Relational Mapper for Project Entities
    class PostsOrm < Sequel::Model(:posts)
      many_to_one :owned_by_posts,
                  class: :'NoFB::Database::GroupsOrm'

      #  many_to_many :contributors,
      #               class: :'CodePraise::Database::MemberOrm',
      #               join_table: :projects_members,
      #             left_key: :project_id, right_key: :member_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(member_info)
        first(post_id: member_info[:post_id]) || create(member_info)
      end
    end
  end
end
