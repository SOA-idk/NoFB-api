# frozen_string_literal: true

require 'http'
require_relative 'facebook_api'

module Utility
  # Utility class
  class Util
    attr_reader :http_error

    module Errors
      # NotFound = 404
      class NotFound < StandardError; end

      # Unauthoirized = 403
      class Unauthorized < StandardError; end

      # BadRequest = 400
      class BadRequest < StandardError; end
    end

    def initialize
      @http_error = {
        400 => Errors::BadRequest, # bad request
        401 => Errors::Unauthorized,
        404 => Errors::NotFound
      }.freeze
    end

    def successful?(result)
      !@http_error.keys.include?(result.code)
    end
  end
end
