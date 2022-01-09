# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Service object interacting with external/internal infrastructure
    class ShowOneGroup
      include Dry::Transaction

      step :show_all

      private

      def show_all(input)
        content = Repository::For.klass(Entity::Group).find_id(input[:group_id])
        Response::ApiResult.new(status: :ok, message: content)
                           .then { |result| Success(result) }
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Having trouble accessing Database.'))
      end
    end
  end
end
