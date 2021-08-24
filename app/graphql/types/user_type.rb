module Types
  class UserType < Types::BaseObject
    description 'This is user type'

    field :id, ID, null: false
    field :email, String, null: true
    field :name, String, null: true
    field :posts, [Types::PostType], null: true
    field :posts_count, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :made_up_name, String, null: false, resolver_method: :nickname
    field :role, Types::UserRoleType, null: false do
      argument :user_type, String, required: false
    end

    def posts_count
      object.posts.size
    end

    def nickname
      case object.name
      when /duc/
        "#{object.name} - The Admin"
      when /juta/
        "#{object.name} - The Moderator"
      else
        "#{object.name} - The User"
      end
    end

    def role(user_type:)
      case user_type
      when /admin/
        'ADMIN'
      when /mod/
        'MOD'
      else
        'USER'
      end
    end
  end
end
