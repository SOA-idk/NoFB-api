# frozen_string_literal: true

require_relative 'post'
require_relative 'posts'
require_relative 'group'
require_relative 'subscribes'
require_relative 'users'

module NoFB
  module Repository
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        Entity::Post => Post,
        Entity::Posts => Posts,
        Entity::Subscribes => Subscribes,
        Entity::Group => Group,
        Entity::User => Users
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
