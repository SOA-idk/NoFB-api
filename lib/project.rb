# frozen_string_literal: false

module NoFB
  # posts class
  class Posts
    attr_reader :posts

    def initialize(posts)
      @posts = posts.map { |content| Post.new(content) }
    end

    def size
      @size = posts.length
    end

    def post_list
      @post_list = posts.map(&:id)
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
