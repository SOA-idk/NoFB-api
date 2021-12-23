# frozen_string_literal: true

require 'dry/transaction'

module NoFB
  module Service
    # Service object interacting with external/internal infrastructure
    class AddSubscriptions
      include Dry::Transaction

      step :parse_url
      step :find_subscribes
      step :store_subscribes
      step :show_subscribes

      private

      URL_ERROR = 'Facebook url is wrong, please check it.'
      DB_FIND_ERROR = 'Having trouble accessing Database(finding).'
      DB_STORE_ERROR = 'Having trouble store Database.'
      DB_SHOW_ERROR = 'Having trouble show Database.'
      URL_REGEX = %r{(https?)://(www.)?facebook\.com}

      def parse_url(input)
        Failure(Response::ApiResult.new(status: :not_found, message: URL_ERROR)) unless URL_REGEX.match?(input['fb_url'])

        user_id = '123'
        group_id = input['fb_url'].downcase.split('/')[-1..][0].strip
        subscribed_word = input['subscribed_word']
        Success(group_id: group_id, subscribed_word: subscribed_word, user_id: user_id)
      end

      def find_subscribes(input)
        if subscribe_in_database(input).nil?
          Success(input)
        else
          Failure(Response::ApiResult.new(
                    status: :bad_request,
                    message: 'You already subscribe to this group, go to edit it.'
                  ))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_FIND_ERROR))
      end

      def store_subscribes(input)
        create_group(input)
        create_subscribes(input)
        Success(input)
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_STORE_ERROR))
      end

      def show_subscribes(input)
        # show all current subscribed word
        content = Repository::For.klass(Entity::Subscribes)
                                 .find_all(user_id: input[:user_id])

        Response::SubscribesList.new(content)
                                .then { |list| Response::ApiResult.new(status: :created, message: list) }
                                .then { |result| Success(result) }
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_SHOW_ERROR))
      end

      def subscribe_in_database(input)
        Repository::For.klass(Entity::Subscribes).find_id(input[:user_id], input[:group_id])
      end

      def create_group(input)
        Repository::For.klass(Entity::Group)
                       .db_find_or_create(group_id: input[:group_id],
                                          group_name: 'Test1')
      rescue StandardError => e
        puts "#{e.class.name} #{e.message}"
        puts e.backtrace.join("\n")
        raise "Could't find or create a group"
      end

      def create_subscribes(input)
        Repository::For.klass(Entity::Subscribes)
                       .db_create(group_id: input[:group_id],
                                  word: input[:subscribed_word],
                                  user_id: input[:user_id])
      rescue StandardError => e
        puts "#{e.class.name} #{e.message}"
        puts e.backtrace.join("\n")
        raise "Could't find or create subscriptions"
      end
    end
  end
end
