# frozen_string_literal: false

module NoFB
    # posts class
    class Posts
      def initialize(posts)
        @posts = posts.map { |x| Post.new(x) }
      end

      def posts
        @posts
      end
  
      def size
        @size = posts.length
      end
  
      def post_list
        @post_list = posts.map { |x| x.id }
      end
    end
  
    # post class
    class Post
      def initialize(post_data)
        @post_data = post_data
      end
  
      def updated_time
        @updated_time = @post_data['updated_time']
      end
  
      def message
        @message = @post_data['message']
      end
  
      def id
        @id = @post_data['id']
      end
    end
  end
  