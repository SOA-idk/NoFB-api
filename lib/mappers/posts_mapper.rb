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
      def build_entities(project_data)
        project_data = project_data['data']
        posts = Array.new

        project_data.each do |data|
          posts << DataMapper.new(data, token, @gateway_class).build_entity
        end

        NoFB::Entity::Posts.new(
          posts: posts,
          size: posts.length,
          post_list: posts.map(&:id)
        )
      end
    
      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, token, gateway_class)
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
          return @data['updated_time']
        end

        def message
          return @data['message']
        end

        def id
          return @data['id']
        end

        def 
      end
    end
  end
end
