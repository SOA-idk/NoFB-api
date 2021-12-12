# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Delete Subscriptions
    class DeleteSubscriptions
      include Dry::Transaction

      step :create_query

      private
      DB_ERROR = 'Having trouble accessing Database.'
      PATH_ERROR = 'Having no subscription on this group.'

      def create_query(input)
        unless find_in_db?(input)
          Repository::For.klass(Entity::Subscribes).delete(input)
          Repository::For.klass(Entity::Subscribes).find_id(input['user_id'], input['group_id'])
                         .then { |record| Response::SubscribesList.new(record) }
                         .then { |response| Response::ApiResult.new(status: :ok, message: response) }
                         .then { |result| Success(result) }
        end
        Failure(Response::ApiResult.new(status: :no_content, message: PATH_ERROR))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERROR))
      end

      def find_in_db?(input)
        query = Repository::For.klass(Entity::Subscribes).query(input)
        query.nil?
      end
    end
  end
end
