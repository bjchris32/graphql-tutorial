module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # queries are just represented as fields
    # `all_links` is automatically camelcased to `allLinks`
    field :all_links, resolver: Resolvers::LinksSearch
  end
end
