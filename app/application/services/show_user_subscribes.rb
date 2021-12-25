# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Service object interacting with external/internal infrastructure
    class ShowUserSubscribes
      include Dry::Transaction

      step :show_all

      private

      def show_all(input)
        content = Repository::For.klass(Entity::Subscribes).find_all(input[:user_id])

        # if content is nil (empty)
        Response::ApiResult.new(status: :ok, message: content) if content.nil?

        # there is content
        Response::SubscribesList.new(content)
                                .then { |list| Response::ApiResult.new(status: :ok, message: list) }
                                .then { |result| Success(result) }
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Having trouble accessing Database.'))
      end
    end
  end
end
