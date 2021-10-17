# frozen_string_literal: true

require 'http'
require_relative 'project'

module NoFB
  # Library for Github Web API
  class FBApi
    API_PROJECT_ROOT = 'https://graph.facebook.com/'

    module Errors
      class NotFound < StandardError; end

      class Unauthorized < StandardError; end

      class BadRequest < StandardError; end
    end

    HTTP_ERROR = {
      400 => Errors::BadRequest, # bad request
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

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

      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end
