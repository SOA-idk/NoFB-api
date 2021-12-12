# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Service object interacting with external/internal infrastructure
    class ShowUsers
      include Dry::Transaction

      step :show_all

      private

      def show_all
        users = Repository::For.klass(Entity::User).all
        Response::UsersList.new(users)
                           .then { |userlist| Response::ApiResult.new(status: :ok, message: userlist) }
                           .then { |result| Success(result) }
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Having trouble accessing Database.'))
      end
    end
  end
end
