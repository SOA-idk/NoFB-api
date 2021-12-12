# frozen_string_literal: true

module NoFB
  module Response
    # List of projects
    UsersList = Struct.new(:users)
    GroupsList = Struct.new(:groups)
    SubscribesList = Struct.new(:subscribes)
    PostsList = Struct.new(:posts)
    Subscribe = Struct.new(:subscribe)
  end
end
