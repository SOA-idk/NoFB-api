# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module NoFB
  module Entity
    # Domain entity for team members
    class Subscribes < Dry::Struct
      include Dry.Types

      attribute :user_id, Strict::String
      attribute :group_id, Strict::String
      attribute :word, String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
