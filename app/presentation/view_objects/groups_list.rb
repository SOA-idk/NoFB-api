# frozen_string_literal: true

require_relative 'group'

module View
  # A list with lots of group which belong to same user
  class GroupsList
    attr_reader :user_id

    def initialize(groups, user_id)
      @user_id = user_id
      @groups = groups.map.with_index { |group, index| Group.new(group, user_id, index) }
    end

    def each(&block)
      @groups.each(&block)
    end

    def any?
      @groups.any?
    end
  end
end
