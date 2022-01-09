# frozen_string_literal: true

module NoFB
  module FB
    # Data Mapper: FB -> Posts entity
    class PostsMapper
      def initialize(fb_token, gateway_class = FB::Api)
        @token = fb_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(group_id)
        data = @gateway.posts(group_id)
        build_entities(data, group_id)
      end

      # build a lot posts
      # :reek:FeatureEnvy
      def build_entities(project_data, group_id)
        project_data = project_data['data']
        posts = build_posts(project_data, group_id)
        NoFB::Entity::Posts.new(
          posts: posts,
          size: posts.length,
          post_list: posts.map(&:post_id),
          group_id: group_id,
          group_name: group_id.to_s
        )
      end

      # :reek:UtilityFunction
      def build_posts(project_data, group_id)
        posts = []
        project_data.each do |data|
          posts << DataMapper.new(data, group_id).build_entity
        end
        posts
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, group_id)
          @data = data
          @group_id = group_id
        end

        def build_entity
          NoFB::Entity::Post.new(
            updated_time: updated_time,
            message: message,
            post_id: post_id,
            user_name: user_name,
            group_id: group_id
          )
        end

        def updated_time
          @data['updated_time']
        end

        def message
          @data['message']
        end

        def post_id
          @data['id']
        end

        def user_name
          '100000130616092'
        end

        attr_reader :group_id
      end
    end
  end
end
