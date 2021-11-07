# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module NoFB
  module Entity
    # Domain entity for team members
    class User < Dry::Struct
      include Dry.Types
      attribute :access_token, String.optional
      attribute :user_email, String.optional
      attribute :user_id, Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
