# frozen_string_literal: true

module View
  # Subscribed word with responding group_url
  class Subscribes
    def initialize(subscribes)
      @subscribes = subscribes
    end

    def entity
      @subscribes
    end

    def group_url
      "https://www.facebook.com/groups/#{@subscribes.group_id}"
    end

    def word
      @subscribes.word
    end
  end
end
