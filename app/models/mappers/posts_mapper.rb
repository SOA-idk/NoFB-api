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
        build_entities(data)
      end

      # build a lot posts
      # :reek:UtilityFunction
      def build_entities(project_data)
        project_data = project_data['data']
        posts = []

        project_data.each do |data|
          posts << DataMapper.new(data).build_entity
        end

        NoFB::Entity::Posts.new(
          posts: posts,
          size: posts.length,
          post_list: posts.map(&:id)
        )
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          NoFB::Entity::Post.new(
            updated_time: updated_time,
            message: message,
            id: id
          )
        end

        def updated_time
          @data['updated_time']
        end

        def message
          @data['message']
        end

        def id
          @data['id']
        end
      end
    end
  end
end
