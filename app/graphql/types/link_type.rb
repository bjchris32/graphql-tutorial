module Types
  class LinkType < Types::BaseObject
    field :id, ID, null: false
    field :url, String, null: false
    field :description, String, null: false
    # `posted_by` is automatically camelcased as `postedBy`
    # field can be nil, because we added users relationship later
    # "method" option remaps field to an attribute of Link model
    # refer to: https://graphql-ruby.org/fields/introduction#field-resolution
    field :posted_by, UserType, null: true, method: :user
    field :votes, [VoteType], null: false
  end
end
