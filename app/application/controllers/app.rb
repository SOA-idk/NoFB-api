# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module NoFB
  # Web App
  # rubocop:disable Metrics/ClassLength
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'confirm.js'
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    # run in background
    crawler = Value::WebCrawler.new # (headless: true)


    # rubocop:disable Metrics/BlockLength
    route do |routing|
      routing.assets # load CSS, JS
      routing.public # make GET public/images/

      # GET /
      routing.root do
        session[:watching] ||= []
        view 'home' # , locals: { posts: posts }
      end

      routing.on 'init' do
        # posts = Repository::For.klass(Entity::Posts).all
        Database::UsersOrm.find_or_create(user_id: '123',
                                          user_email: 'hhoracehsu@@gmail.com',
                                          user_name: '242234',
                                          user_img: 'img test')

        Database::GroupsOrm.find_or_create(group_id: '4534',
                                           group_name: 'lalalala')

        Database::GroupsOrm.find_or_create(group_id: '8787',
                                           group_name: 'Idiot')

        Database::SubscribesOrm.create(user_id: '123',
                                       group_id: '4534',
                                       word: 'cookies, sell')
        Database::SubscribesOrm.create(user_id: '123',
                                       group_id: '8787',
                                       word: 'Bread')
        view 'home'
      end

      routing.on 'testLogin' do
        crawler.login
        view 'show_browser'
      end

      routing.on 'testWait' do
        crawler.wait_home_ready
        view 'show_browser'
      end

      routing.on 'testDriver' do
        crawler.test
        view 'show_browser'
      end

      routing.on 'showBrowser' do
        view 'show_browser'
      end

      routing.on 'goto_group_page_anyway' do
        crawler.goto_group_page_anyway
        view 'show_browser'
      end

      routing.on 'updateDB' do
        crawler.crawl
        puts crawler.construct_query
        crawler.insert_db
        # puts Database::PostsOrm.all
        view 'show_browser'
      end

      routing.on 'testMail' do
        Value::SendEmail.send_simple_message
      end

      routing.on 'add' do
        routing.is do
          # GET /add/
          routing.get do
            view 'add'
          end
          # POST /add/
          routing.post do
            # user_id = '123'
            url_request = Forms::NewSubscription.new.call(routing.params)
            subscription_made = Service::AddSubscriptions.new.call(url_request)

            if subscription_made.failure?
              flash[:error] = subscription_made.failure
              routing.redirect 'user'
            end

            sub = subscription_made.value!
            session[:watching].insert(0, "#{sub.user_id}/#{sub.group_id}").uniq!
            flash[:notice] = 'Successfully subscribe to specific word(s).'

            routing.redirect 'user'
          end
        end
      end

      routing.on 'group' do
        routing.on String do |group_id|
          puts "fb_token: #{App.config.FB_TOKEN}"
          puts "last / group_id: #{group_id}\n"
          # GET /group/group_id
          routing.get do
            # Get project from database
            puts "rebuild / group_id: #{group_id}\n"
            posts = Repository::For.klass(Entity::Posts)
                                   .find_group_id(group_id.to_s)

            view 'posts', locals: { posts: posts }
          end
        end
      end

      routing.on 'user' do
        # /user request
        routing.is do
          # GET /user request
          routing.get do
            groups = Repository::For.klass(Entity::Subscribes)
                                    .find_all('123')

            flash.now[:notice] = 'Start to subscribe to a word!!' if groups.none?

            viewable_groups = View::GroupsList.new(groups, 'user')
            view 'user', locals: { groups: viewable_groups }
          end
        end

        # DELETE /user/groupId request
        routing.on String do |group_id|
          routing.delete do
            user_id = '123'
            delete_sub = Service::DeleteSubscriptions.new.call(group_id: group_id, user_id: user_id)

            if delete_sub.failure?
              flash[:error] = 'Having trouble accessing Database'
              routing.redirect '/user'
            end

            delete_path = delete_sub.value!
            session[:watching].delete(delete_path)
            flash[:notice] = 'Successfully unsubscribe !'

            routing.redirect '/user'
          end

          # GET /user/groupId
          routing.get do
            user_id = '123'
            subscribes = Repository::For.klass(Entity::Subscribes)
                                        .find_id(user_id, group_id)
            viewable_subscribes = View::Subscribes.new(subscribes)
            view 'subscribe', locals: { subscribes: viewable_subscribes }
          end

          # UPDATE /user/groupId
          routing.patch do
            user_id = '123'
            update_request = Forms::UpdateSubscription.new.call(routing.params)
            update_made = Service::UpdateSubscription.new.call(user_id: user_id,
                                                               group_id: group_id,
                                                               word: update_request[:subscribed_word])

            if update_made.failure?
              flash[:error] = "Can't update the subscribed word!"
            else
              flash[:notice] = 'Successfully update subscribed words !'
            end

            routing.redirect '/user'
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/ClassLength
end
