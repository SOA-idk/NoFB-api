# frozen_string_literal: true

require 'sequel'

module NoFB
  module Database
    # Object Relational Mapper for Project Entities
    class PostsOrm < Sequel::Model(:posts)
      many_to_one :owned_by_posts,
                  class: :'NoFB::Database::GroupsOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(member_info)
        PostsOrm.strict_param_setting = false
        first(post_id: member_info[:post_id]) || insert(member_info)
      end
    end
  end
end
