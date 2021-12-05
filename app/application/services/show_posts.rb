# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Service object interacting with external/internal infrastructure
    class ShowPosts
      include Dry::Transaction

      step :show_all

      private

      def show_all
        content = Repository::For.klass(Entity::Posts).all
        Response::PostsList.new(content)
                           .then do |list|
          Success(Response::ApiResult.new(status: :ok, message: list))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Having trouble accessing Database.'))
      end
    end
  end
end
