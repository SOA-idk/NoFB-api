# frozen_string_literal: true

module CodePraise
  module Response
    # List of projects
    UsersList = Struct.new(:users)
    GroupsList = Struct.new(:groups)
    SubscribesList = Struct.new(:subscribes)
    PostsList = Struct.new(:posts)
  end
end
