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
      routing.public

      # GET /
      routing.root do
        # posts = Repository::For.klass(Entity::Posts).all
        view 'home' # , locals: { posts: posts }
      end

      routing.on 'group' do
        routing.is do
          # POST /project/
          routing.post do
            fb_url = routing.params['fb_url'].downcase
            routing.halt 400 unless (fb_url.include? 'facebook.com') &&
                                    (fb_url.split('/').count >= 5)
            group_id = fb_url.split('/')[-1..][0].strip

            puts "group / groupId: #{group_id}"
            # routing.redirect "group/#{group_id}"
            # Get project from Github
            posts = FB::PostsMapper.new(App.config.FB_TOKEN)
                                   .find(group_id)

            # Add project to database
            Repository::For.entity(posts).create(posts)

            # Redirect viewer to project page
            routing.redirect "group/#{group_id}"
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
    end
    # rubocop:enable Metrics/BlockLength
  end
end
