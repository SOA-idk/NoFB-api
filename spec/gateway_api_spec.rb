require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'

describe 'Tests FB Group API' do
  before do 
    VcrHelper.configure_vcr_for_fb
  end

  after do 
    VcrHelper.eject_vcr
  end
  
  describe 'Posts information' do
    it 'HAPPY: should provide correct posts attributes' do
      # puts CORRECT['data'].length()
      # puts CORRECT['data'].map { |x| x['id'] }
      # posts = NoFB::FBApi.new(ACCESS_TOKEN).posts(GROUP_ID)
      posts = NoFB::FB::PostsMapper.new(ACCESS_TOKEN).find(GROUP_ID)
  
      _(posts.size).must_equal CORRECT['data'].length()
      _(posts.post_list).must_equal CORRECT['data'].map { |x| x['id'] }
    end
    it 'SAD: should raise exception on non-exit group id' do
      _(proc do
        NoFB::FB::PostsMapper.new(ACCESS_TOKEN).find('4653165156') # non-exit group id
      end).must_raise NoFB::FB::Api::Response::BadRequest
    end
  
    it 'SAD: should raise exception on error access token' do
      _(proc do
        NoFB::FB::PostsMapper.new('sdfjiofasgacds').find(GROUP_ID) # error access token
      end).must_raise NoFB::FB::Api::Response::BadRequest
    end
  end

  describe 'Post information' do
    before do
      @posts = NoFB::FB::PostsMapper.new(ACCESS_TOKEN).find(GROUP_ID)
    end
    it 'HAPPY: should recognize Posts' do
      _(@posts).must_be_kind_of NoFB::Entity::Posts
    end

    it 'HAPPY: should updated_time' do
      @posts.posts.each_with_index.each { |post, idx|
        _(post.updated_time).must_equal CORRECT['data'][idx]['updated_time']
      }
    end
    it 'HAPPY: should message' do
      @posts.posts.each_with_index.each { |post, idx|
        _(post.message).must_equal CORRECT['data'][idx]['message']
      }
    end
    it 'HAPPY: should id' do
      @posts.posts.each_with_index.each { |post, idx|
        _(post.post_id).must_equal CORRECT['data'][idx]['id']
      }
    end
  end
end
