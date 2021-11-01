# frozen_string_literal: true

require 'roda'
require 'slim'

module NoFB
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        # render home.slim into HTML
        view 'home'
      end

      routing.on 'group' do
        routing.is do
          # POST /project/
          routing.post do
            fb_url = routing.params['fb_url'].downcase
            routing.halt 400 unless (fb_url.include? 'facebook.com') &&
                                    (fb_url.split('/').count >= 5)
            group_id = fb_url.split('/')[-1..][0].strip

            routing.redirect "group/#{group_id}"
          end
        end

        routing.on String do |group_id|
          puts "fb_token: #{FB_TOKEN}"
          puts "group_id: #{group_id}"
          # GET /group/group_id
          routing.get do
            fb_posts = FB::PostsMapper
                       .new(FB_TOKEN)
                       .find(group_id)

            view 'posts', locals: { posts: fb_posts }
          end
        end
      end
    end
  end
end
