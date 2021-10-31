# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'post'

module NoFB
  module Entity
    # Domain entity for team members
    class Posts < Dry::Struct
      include Dry.Types

      attribute :posts, Strict::Array.of(Post)
      attribute :size, Strict::Integer
      attribute :post_list, Strict::Array.of(String)
      attribute :group_id, Strict::String
    end
  end
end
