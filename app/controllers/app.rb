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
                                          user_email: '4534@gmail.com',
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

      routing.on 'add' do
        routing.is do
          # GET /add/
          routing.get do
            view 'add'
          end
          # POST /add/
          routing.post do
            fb_url = routing.params['fb_url'].downcase
            routing.halt 400 unless (fb_url.include? 'facebook.com') &&
                                    (fb_url.split('/').count >= 5)
            group_id = fb_url.split('/')[-1..][0].strip
            subscribed_word = routing.params['subscribed_word']

            # Check if group is in database
            begin
              user_id = '123'
              if Repository::Subscribes.find_id(user_id, group_id).nil?
                Database::GroupsOrm.find_or_create(group_id: group_id,
                                                   group_name: 'Test1')
                Database::SubscribesOrm.create(group_id: group_id,
                                               word: subscribed_word,
                                               user_id: user_id)
              else # group already exist
                flash[:error] = 'You already subscribe to this group, go to edit it.'
                routing.redirect 'user'
              end
            rescue StandardError
              flash[:error] = 'Having trouble accessing Database.'
              routing.redirect '/'
            end

            session[:watching].insert(0, "#{user_id}/#{group_id}").uniq!
            # Redirect viewer to project page
            routing.redirect 'user'
          end
        end

        # current path does not exist
        routing.on String do |group_id|
          puts "fb_token: #{App.config.FB_TOKEN}"
          puts "last / group_id: #{group_id}\n"
          # GET /group/group_id
          routing.get do
            # Get project from database
            puts "rebuild / group_id: #{group_id}\n"
            posts = Repository::For.klass(Entity::Posts)
                                   .find_user_id_group_id('100000130616092', group_id.to_s)

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
            begin
              query = Database::SubscribesOrm[group_id: group_id, user_id: user_id]
              unless query.nil?
                query.delete

                session[:watching].delete("#{user_id}/#{group_id}")
                flash[:notice] = 'Successfully unsubscribe !'
              end
            rescue StandardError
              flash[:error] = 'Having trouble accessing Database'
            end
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
            subscribed_word = routing.params['subscribed_word']
            begin
              sub = Entity::Subscribes.new(user_id: user_id,
                                           group_id: group_id,
                                           word: subscribed_word)
              Repository::For.klass(Entity::Subscribes)
                             .db_update_or_create(sub)

              flash[:notice] = 'Successfully update subscribed words !'
            rescue StandardError
              flash[:error] = "Can't update the subscribed word!"
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
