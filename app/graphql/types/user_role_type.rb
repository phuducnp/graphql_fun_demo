module Types
  class UserRoleType < Types::BaseEnum
    value 'ADMIN', 'The one above all'
    value 'MOD', 'Moderator'
    value 'USER', 'User'
  end
end
