require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/facebook_api'

GROUP_ID = '302165911402681'
CONFIG = YAML.safe_load(File.read('../config/secrets.yml'))
ACCESS_TOKEN = CONFIG['FB_TOKEN']
CORRECT = YAML.safe_load(File.read('./fixtures/nofb_results.yml'))


describe 'Tests FB Group API' do
  describe 'Posts information' do
    it 'HAPPY: should provide correct posts attributes' do
      # puts CORRECT['data'].length()
      # puts CORRECT['data'].map { |x| x['id'] }
      posts = NoFB::FBApi.new(ACCESS_TOKEN).posts(GROUP_ID)
      _(posts.size).must_equal CORRECT['data'].length()
      _(posts.post_list).must_equal CORRECT['data'].map { |x| x['id'] }
    end
    it 'SAD: should raise exception on non-exit group id' do
      _(proc do
        NoFB::FBApi.new(ACCESS_TOKEN).posts('4653165156') # non-exit group id
      end).must_raise NoFB::FBApi::Errors::BadRequest
    end
  
    it 'SAD: should raise exception on error access token' do
      _(proc do
        NoFB::FBApi.new('sdfjiofasgacds').posts(GROUP_ID) # error access token
      end).must_raise NoFB::FBApi::Errors::BadRequest
    end
  end

  describe 'Post information' do
    before do
      @posts = NoFB::FBApi.new(ACCESS_TOKEN).posts(GROUP_ID)
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
        _(post.id).must_equal CORRECT['data'][idx]['id']
      }
    end
  end
end
