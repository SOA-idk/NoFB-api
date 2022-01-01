# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # add user Line notification key
    class AddUserNotify
      include Dry::Transaction

      step :add_notify
      step :show_user

      private

      DB_ERROR = 'Having trouble accessing Database.'
      DUPLICATE_ERROR = 'User is already in database'

      def add_notify(input)
        Repository::For.klass(Entity::Notify)
                       .db_create(user_id: input['user_id'],
                                  user_access_token: input['access_token'])
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERROR))
      end

      def show_user(input)
        # show all current subscribed word
        content = Repository::For.klass(Entity::Notify)
                                 .find_id(input['user_id'])
        Response::ApiResult.new(status: :created, message: content)
                           .then { |result| Success(result) }
      end
    end
  end
end
