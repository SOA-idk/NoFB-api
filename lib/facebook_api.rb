# frozen_string_literal: true

require 'http'
require_relative 'project'
require_relative 'util'

module NoFB
  # Library for Github Web API
  class FBApi
    API_PROJECT_ROOT = 'https://graph.facebook.com/'

    def initialize(token)
      @fb_token = token
    end

    def posts(group_id)
      project_req_url = fb_api_path("#{group_id}/feed")
      project_data = JSON.parse(call_fb_url(project_req_url))
      project_data = project_data['data']

      Posts.new(project_data)
    end

    private

    def fb_api_path(path)
      "#{API_PROJECT_ROOT}/#{path}?access_token=#{@fb_token}"
    end

    def call_fb_url(url)
      result = HTTP.headers('Accept' => 'application/json; charset=UTF-8').get(url)
      # puts result.code
      # puts successful?(result)
      Utility::Util.new.successful?(result) ? result : raise(Utility::Util.new.http_error[result.code])
    end
  end
end
