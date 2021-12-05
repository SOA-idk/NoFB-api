# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module NoFB
  module Representer
    #  Represents Group information for API output
    class User < Roar::Decorator
      include Roar::JSON

      property :user_id
      property :user_name
      property :user_email
    end
  end
end
