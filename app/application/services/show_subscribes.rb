# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Service object interacting with external/internal infrastructure
    class ShowSubscribes
      include Dry::Transaction

      step :show_all

      private

      def show_all
        content = Repository::For.klass(Entity::Subscribes).all
        Response::ProjectFolderContributions.new(content)
                                            .then do |appraisal|
          Success(Response::ApiResult.new(status: :ok, message: appraisal))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Having trouble accessing Database.'))
      end
    end
  end
end
