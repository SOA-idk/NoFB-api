# frozen_string_literal: true

module View
  # User in NoFB
  class User
    def initialize(user)
      @user = user
    end

    def entity
      @user
    end
  end
end
