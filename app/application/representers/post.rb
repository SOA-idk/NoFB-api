# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module NoFB
  module Representer
    #  Represents Group information for API output
    class Post < Roar::Decorator
      include Roar::JSON

      property :post_id
      property :updated_at
      property :message
      property :user_name
      property :group_id
    end
  end
end
