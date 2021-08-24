module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # /users
    field :users, [Types::UserType], null: false
    def users
      User.all
    end

    field :posts, [Types::PostType], null: false
    def posts
      Post.all
    end

    # /user/:id
    field :user, Types::UserType, null: false do
      description 'Find a user by ID'
      argument :id, ID, required: true
    end
    def user(id:)
      User.find(id)
    end

    # /post/:id
    field :post, Types::PostType, null: false do
      description 'Find a post by ID'
      argument :id, ID, required: true
    end
    def post(id:)
      Post.find(id)
    end

    # Change format of response field
    field :paid_user, Types::UserType, null: false do
      description 'Find a paid user by ID'
      argument :id, ID, required: true
    end
    def paid_user(id:)
      user = User.find(id)
      {
        name: "Mr.#{user.name}"
      }
    end
  end
end
