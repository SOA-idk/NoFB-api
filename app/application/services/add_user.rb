# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Service object interacting with external/internal infrastructure
    class AddUser
      include Dry::Transaction

      step :find_user
      step :create_user
      step :show_user

      private

      DB_ERROR = 'Having trouble accessing Database.'
      DUPLICATE_ERROR = 'User is already in database'

      def find_user(input)
        # check whether user is in database
        if user_in_database(input).nil?
          Success(input)
        else
          Failure(Response::ApiResult.new(
                    status: :conflict,
                    message: DUPLICATE_ERROR
                  ))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERROR))
      end

      def create_user(input)
        Repository::For.klass(Entity::User)
                       .db_create(user_id: input['user_id'],
                                  user_email: input['user_email'],
                                  user_name: input['user_name'],
                                  user_img: input['user_img'])
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERROR))
      end

      def show_user(input)
        # show all current subscribed word
        content = Repository::For.klass(Entity::User)
                                 .find_id(input['user_id'])
        Response::ApiResult.new(status: :created, message: content)
                           .then { |result| Success(result) }
      end

      def user_in_database(input)
        Repository::For.klass(Entity::User).find_id(input['user_id'])
      end
    end
  end
end
