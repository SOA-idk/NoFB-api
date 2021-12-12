# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Delete Subscriptions
    class UpdateSubscription
      include Dry::Transaction

      step :update_query
      step :show_subscribe

      private

      DB_ERROR = 'Having trouble accessing Database.'

      def update_query(input)
        puts 'update_query:'
        puts input
        sub = Entity::Subscribes.new(user_id: input[:user_id],
                                     group_id: input[:group_id],
                                     word: input[:word])
        puts 'db_update'
        Repository::For.klass(Entity::Subscribes)
                       .db_update_or_create(sub)
        Success(user_id: input[:user_id], group_id: input[:group_id], word: input[:word])
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERROR))
      end

      def show_subscribe(input)
        puts 'show sub'
        Repository::For.klass(Entity::Subscribes).find_id(input[:user_id], input[:group_id])
                       .then { |record| Response::Subscribe.new(record) }
                       .then { |response| Response::ApiResult.new(status: :ok, message: response) }
                       .then { |result| Success(result) }

      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERROR))
      end
    end
  end
end
