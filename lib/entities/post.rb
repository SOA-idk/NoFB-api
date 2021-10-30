# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module NoFB
  module Entity
    # Domain entity for team members
    class Post < Dry::Struct
      include Dry.Types

      attribute :id, Strict::String
      attribute :message, String.optional
      attribute :updated_time, Strict::String
    end
  end
end
