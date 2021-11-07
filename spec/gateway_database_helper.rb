# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Github API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_fb
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store posts' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save posts from Github to database' do
      posts = NoFB::FB::PostsMapper.new(ACCESS_TOKEN).find(GROUP_ID)

      rebuilt = NoFB::Repository::For.entity(posts).create(posts)

      _(rebuilt.size).must_equal(posts.size)
      _(rebuilt.post_list).must_equal(posts.post_list)

    #   posts.contributors.each do |member|
    #     found = rebuilt.contributors.find do |potential|
    #       potential.size == member.size
    #     end

    #     _(found.userpost_list).must_equal member.userpost_list
    #     # not checking email as it is not always provided
    #   end
    end
  end
end
