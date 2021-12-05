# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module NoFB
  module Representer
    #  Represents Group information for API output
    class Subscribes < Roar::Decorator
      include Roar::JSON

      property :user_id
      property :group_id
      property :word
    end
  end
end
