# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # add user Line notification key
    class FindUserNotify
      include Dry::Transaction

      step :find_user

      private

      DB_ERROR = 'Having trouble accessing Database.'
      NOT_EXIST = 'User notification is not in database.'

      def find_user(input)
        # show all current subscribed word
        content = Repository::For.klass(Entity::Notify)
                                 .find_id(input[:user_id])
        if content.nil?
          Failure(Response::ApiResult.new(status: :not_found, message: NOT_EXIST))
        else
          Response::ApiResult.new(status: status, message: content)
                             .then { |result| Success(result) }
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERROR))
      end
    end
  end
end
