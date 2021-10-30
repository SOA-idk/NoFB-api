# frozen_string_literal: true

require 'http'

module NoFB
  # Library for Github Web API
  module FB
    # just Api
    class Api
      def initialize(token)
        @fb_token = token
      end

      def posts(group_id)
        JSON.parse(Request.new(@fb_token).posts(group_id))
        # Posts.new(project_data)
      end

      # Sends out HTTP requests to Github
      class Request
        API_PROJECT_ROOT = 'https://graph.facebook.com/'
        def initialize(token)
          @token = token
        end

        def posts(group_id)
          get("#{API_PROJECT_ROOT}/#{group_id}/feed?access_token=#{@token}")
        end

        # :reek:FeatureEnvy
        def get(url)
          http_response = HTTP.headers(
            'Accept' => 'application/json; charset=UTF-8'
          ).get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from Github with success/error
      class Response < SimpleDelegator
        # Unauthorized 401 descriptive comment
        Unauthorized = Class.new(StandardError)

        # NotFound 404 descriptive comment
        NotFound = Class.new(StandardError)

        # BadRequest 400 descriptive comment
        BadRequest = Class.new(StandardError)

        HTTP_ERROR = {
          401 => Unauthorized,
          404 => NotFound,
          400 => BadRequest
        }.freeze

        def successful?
          !HTTP_ERROR.keys.include?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
