# frozen_string_literal: true

require 'roda'
require 'slim'

module NoFB
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :public, root: 'app/views/public'
    plugin :assets, path: 'app/views/assets',
                    css: 'style.css'
    plugin :halt

    # rubocop:disable Metrics/BlockLength
    route do |routing|
      routing.assets # load CSS
      routing.public # make GET public/images/

      # GET /
      routing.root do
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

            puts "group / groupId: #{group_id}"
            puts "subscribed_word: #{subscribed_word}"
            # routing.redirect "add/#{group_id}"
            # TODO, false detection
            # Check if it's in database
            if Repository::Subscribes.find_id('123', group_id).nil?
              puts "add new records"
              Database::GroupsOrm.find_or_create(group_id: group_id,
                                              group_name: 'Test1')
              Database::SubscribesOrm.create(group_id: group_id,
                                             word: subscribed_word,
                                             user_id: '123')
            end

            # Redirect viewer to project page
            routing.redirect "user"
          end
        end

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
        groups = Repository::For.klass(Entity::Subscribes)
                               .find_all('123')
        view 'user', locals: {groups: groups}
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
