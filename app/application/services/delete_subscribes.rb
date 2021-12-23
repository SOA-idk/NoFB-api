# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Delete Subscriptions
    class DeleteSubscription
      include Dry::Transaction

      step :delete_subscribes
      step :show_all

      private

      DB_ERROR = 'Having trouble accessing Database.'
      DB_FIND_ERROR = 'Having trouble accessing Database(finding).'
      DB_DEL_ERROR = 'Having trouble deleting.'
      PATH_ERROR = 'Having no subscription on this group.'

      def delete_subscribes(input)
        if find_in_db?(input)
          Failure(Response::ApiResult.new(status: :not_found, message: PATH_ERROR))
        else
          Repository::For.klass(Entity::Subscribes).delete(input)
          Success(input)
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_DEL_ERROR))
      end

      def show_all(input)
        Repository::For.klass(Entity::Subscribes).find_all(user_id: input[:user_id])
                       .then { |record| Response::SubscribesList.new(record) }
                       .then { |response| Response::ApiResult.new(status: :ok, message: response) }
                       .then { |result| Success(result) }
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERROR))
      end

      def find_in_db?(input)
        Repository::For.klass(Entity::Subscribes).query(input).nil?
      rescue StandardError => e
        puts "#{e.class.name} #{e.message}"
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_FIND_ERROR))
      end
    end
  end
end
