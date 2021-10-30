require 'dry-types'
require 'dry-struct'

module NoFB
  module Entity
    # Domain entity for team members
    class Post < Dry::Struct
      include Dry.Types

      attribute :id,        Integer.optional
      attribute :message, Strict::String
      attribute :updated_time,  Strict::String
    end
  end
end