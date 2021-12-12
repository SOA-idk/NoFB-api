# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Delete Subscriptions
    class DeleteSubscription
      include Dry::Transaction

      step :create_query

      private

      DB_ERROR = 'Having trouble accessing Database.'
      PATH_ERROR = 'Having no subscription on this group.'

      def create_query(input)
        unless find_in_db?(input)
          Repository::For.klass(Entity::Subscribes).delete(input)
          Repository::For.klass(Entity::Subscribes).find_all(user_id: input[:user_id])
                         .then { |record| Response::SubscribesList.new(record) }
                         .then { |response| Response::ApiResult.new(status: :ok, message: response) }
                         .then { |result| Success(result) }
        else
          Failure(Response::ApiResult.new(status: :not_found, message: PATH_ERROR))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERROR))
      end

      def find_in_db?(input)
        Repository::For.klass(Entity::Subscribes).query(input).nil?
      end
    end
  end
end
