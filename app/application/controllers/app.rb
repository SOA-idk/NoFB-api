# frozen_string_literal: true

require 'roda'

module NoFB
  # Web App
  # rubocop:disable Metrics/ClassLength
  class App < Roda
    plugin :public

    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    # rubocop:disable Metrics/BlockLength
    route do |routing|
      routing.public # make GET public/images/
      response['Content-Type'] = 'application/json'

      # routing.on 'init' do
      #   # posts = Repository::For.klass(Entity::Posts).all
      #   NoFB::Database::UsersOrm.find_or_create(user_id: '123',
      #                                     user_email: 'hhoracehsu@@gmail.com',
      #                                     user_name: '242234',
      #                                     user_img: 'img test')

      #   NoFB::Database::GroupsOrm.find_or_create(group_id: '4534',
      #                                      group_name: 'lalalala')

      #   NoFB::Database::GroupsOrm.find_or_create(group_id: '8787',
      #                                      group_name: 'Idiot')

      #   NoFB::Database::SubscribesOrm.create(user_id: '123',
      #                                  group_id: '4534',
      #                                  word: 'cookies, sell')
      #   NoFB::Database::SubscribesOrm.create(user_id: '123',
      #                                  group_id: '8787',
      #                                  word: 'Bread')
      # end

      routing.on 'openDriver' do
        Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config).send('openDriver'.to_json)

        message = 'openDriver'
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )
        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'testLogin' do
        Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config).send('testLogin'.to_json)

        message = 'testLogin'
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )
        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'testWait' do
        Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config).send('testWait'.to_json)

        message = 'testWait'
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )
        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'testDriver' do
        Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config).send('testDriver'.to_json)

        message = 'testDriver'
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )
        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'showCrawler' do
        Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config).send('showCrawler'.to_json)

        message = 'showCrawler'
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )
        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'goAnyway' do
        Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config).send('goAnyway'.to_json)

        message = 'goAnyway'
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )
        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'updateDB' do
        Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config).send('updateDB'.to_json)

        message = 'updateDB'
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )
        response.status = result_response.http_status_code
        result_response.to_json
      end

      # GET /
      routing.root do
        message = "NoFB API v1 at /api/v1/ in #{App.environment} mode"
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )
        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        if routing.params['access_key'] == App.config.ACCESS_KEY
          routing.on 'users' do
            routing.is do
              # GET /api/v1/users
              routing.get do
                result = Service::ShowUsers.new.call

                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                Representer::UsersList.new(
                  result.value!.message
                ).to_json
              end

              # POST /api/v1/users?{params}
              routing.post do
                result = Service::AddUser.new.call(routing.params)

                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                Representer::User.new(
                  result.value!.message
                ).to_json
              end
            end

            routing.on String do |user_id|
              # GET /api/v1/users/{user_id}
              routing.get do
                result = Service::FindUser.new.call(user_id: user_id)

                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                Representer::User.new(
                  result.value!.message
                ).to_json
              end
            end
          end

          # PATH /api/v1/notify
          routing.on 'notify' do
            routing.is do
              # POST /api/v1/notify
              routing.post do
                result = Service::AddUserNotify.new.call(routing.params)

                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                Representer::UserNotify.new(
                  result.value!.message
                ).to_json
              end
            end

            # GET /api/v1/notify/{user_id}
            routing.on String do |user_id|
              routing.get do
                result = Service::FindUserNotify.new.call(user_id: user_id)
                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                Representer::UserNotify.new(
                  result.value!.message
                ).to_json
              end
            end
          end

          # GET /api/v1/posts
          routing.on 'posts' do
            routing.get do
              result = Service::ShowPosts.new.call

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              puts Representer::PostsList.new(result.value!.message)
              Representer::PostsList.new(
                result.value!.message
              ).to_json
            end
          end

          # GET /api/v1/groups
          routing.on 'groups' do
            routing.get do
              # PATH /api/v1/groups - show all the groups
              routing.is do
                result = Service::ShowGroups.new.call

                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                Representer::GroupsList.new(
                  result.value!.message
                ).to_json
              end

              # PATH /api/v1/groups/{group_id} - show group name
              routing.on String do |group_id|
                result = Service::ShowOneGroup.new.call(group_id: group_id)

                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                Representer::Group.new(
                  result.value!.message
                ).to_json
              end
            end
          end

          routing.on 'subscribes' do
            # PATH /api/v1/subscribes
            routing.is do
              # GET /api/v1/subscribes - all users' subscription
              routing.get do
                result = Service::ShowSubscribes.new.call

                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                Representer::SubscribesList.new(
                  result.value!.message
                ).to_json
              end

              # POST /api/v1/subscribes?{params}
              routing.post do
                result = Service::AddSubscriptions.new.call(routing.params)

                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                Representer::SubscribesList.new(
                  result.value!.message
                ).to_json
              end
            end

            routing.on String do |user_id|
              # GET /api/v1/subscribes/{user_id}
              routing.get do
                result = Service::ShowUserSubscribes.new.call(user_id: user_id)

                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                Representer::SubscribesList.new(
                  result.value!.message
                ).to_json
              end

              routing.on String do |group_id|
                # DELETE /api/v1/subscribes/{user_id}/{group_id}
                routing.delete do
                  result = Service::DeleteSubscription.new.call(user_id: user_id, group_id: group_id)
                  if result.failure?
                    failed = Representer::HttpResponse.new(result.failure)
                    routing.halt failed.http_status_code, failed.to_json
                  end

                  http_response = Representer::HttpResponse.new(result.value!)
                  response.status = http_response.http_status_code

                  Representer::SubscribesList.new(
                    result.value!.message
                  ).to_json
                end

                # PATCH /api/v1/subscribes/{user_id}/{group_id}
                routing.patch do
                  result = Service::UpdateSubscription.new.call(user_id: user_id,
                                                                group_id: group_id,
                                                                word: routing.params['subscribed_word'])

                  if result.failure?
                    failed = Representer::HttpResponse.new(result.failure)
                    routing.halt failed.http_status_code, failed.to_json
                  end

                  http_response = Representer::HttpResponse.new(result.value!)
                  response.status = http_response.http_status_code

                  Representer::Subscribe.new(
                    result.value!.message.subscribe
                  ).to_json
                end
              end
            end
          end
        else
          message = 'problems about the access_key'
          failed = Representer::HttpResponse.new(
            Response::ApiResult.new(status: :forbidden, message: message)
          )
          # routing.halt failed.http_status_code, failed.to_json
          response.status = failed.http_status_code
          failed.to_json
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/ClassLength
end
