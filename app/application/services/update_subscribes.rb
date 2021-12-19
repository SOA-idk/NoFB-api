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

      REQUEST_ERROR = 'Cannot update unexisted subscribe.'
      DB_ERROR = 'Having trouble accessing Database(db_update).'
      RES_ERROR = 'Having trouble in find or response.'

      def update_query(input)
        result = Repository::For.klass(Entity::Subscribes)
                                .db_update(input)
        if result.nil?
          Failure(Response::ApiResult.new(status: :not_found, message: REQUEST_ERROR))
        else
          Success(user_id: input[:user_id], group_id: input[:group_id], word: input[:word])
        end
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERROR))
      end

      def show_subscribe(input)
        # puts 'show sub'
        Repository::For.klass(Entity::Subscribes).find_id(input[:user_id], input[:group_id])
                       .then { |record| Response::Subscribe.new(record) }
                       .then { |response| Response::ApiResult.new(status: :ok, message: response) }
                       .then { |result| Success(result) }
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: RES_ERROR))
      end
    end
  end
end
