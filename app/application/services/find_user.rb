# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Service object interacting with external/internal infrastructure
    class FindUser
      include Dry::Transaction

      step :show_user

      private

      DB_ERROR = 'Having trouble accessing Database.'
      NOT_EXIST = 'User is not in database.'

      def show_user(input)
        # show all current subscribed word
        content = Repository::For.klass(Entity::User)
                                 .find_id(input[:user_id])
        if content.nil?
          Failure(Response::ApiResult.new(status: :not_found, message: NOT_EXIST))
        else
          Response::ApiResult.new(status: :created, message: content)
                             .then { |result| Success(result) }
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: DB_ERROR))
      end
    end
  end
end
