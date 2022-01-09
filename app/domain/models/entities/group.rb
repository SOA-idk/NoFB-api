# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module NoFB
  module Entity
    # Domain entity for team members
    class Group < Dry::Struct
      include Dry.Types

      attribute :group_name, String.optional
      attribute :group_id, Strict::String
      attribute :updated_at, Time.optional
      attribute :created_at, Time.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
