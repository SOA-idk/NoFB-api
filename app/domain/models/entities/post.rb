# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module NoFB
  module Entity
    # Domain entity for team members
    class Post < Dry::Struct
      include Dry.Types

      attribute :post_id, Strict::String
      attribute :updated_time, Strict::String
      attribute :message, String.optional
      attribute :user_name, String.optional
      attribute :group_id, Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
