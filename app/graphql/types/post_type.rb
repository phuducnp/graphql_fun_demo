module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :title, String, null: true
    field :body, String, null: true
    field :user, UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # def user
    #   object.user # N+1 queries
    # end

    def user
      batch_load_one(object.user_id, 'User')
    end
  end
end
