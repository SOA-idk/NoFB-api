# frozen_string_literal: true

require 'roda'

module NoFB
  # Web App
  class App < Roda
    plugin :public #, root: 'app/presentation/public'

    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    # rubocop:disable Metrics/BlockLength
    route do |routing|
      routing.public # make GET public/images/
      response['Content-Type'] = 'application/json'

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
        if routing.params['access_key'] == '123'
          
          # GET /api/v1/users
          routing.on 'users' do
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

              puts Representer::PostsList.new( result.value!.message )
              Representer::PostsList.new(
                result.value!.message
              ).to_json
            end
          end

          # GET /api/v1/groups
          routing.on 'groups' do
            routing.get do
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
          end

          routing.on 'subscribes' do
            # GET /api/v1/subscribes
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

            # POST /api/v1/subscribes
            routing.post do
              result = Service::AddSubscribes.new.call(fb_url: fb_url, subscribed_word: subscribed_word)

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
end
