# frozen_string_literal: true

require 'dry-validation'

module NoFB
  module Forms
    # update with routing params
    class UpdateSubscription < Dry::Validation::Contract
      params do
        required(:subscribed_word).filled(:string)
      end
    end
  end
end
