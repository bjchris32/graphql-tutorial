require 'search_object'
require 'search_object/plugin/graphql'

# example with filter:
# query {
#   allLinks(filter: { descriptionContains: "Awe", OR: [{urlContains: "bj"}] }) {
#     url
#     description
#   }
# }

# example with pagination
# query {
#   allLinks(first: 3, skip: 2, filter: { descriptionContains: "Awe", OR: [{urlContains: "bj"}] }) {
#     url
#     description
#   }
# }
class Resolvers::LinksSearch
  include SearchObject.module(:graphql)

  scope { Link.all }

  type [Types::LinkType]

  class LinkFilter < ::Types::BaseInputObject
    argument :OR, [self], required: false
    argument :description_contains, String, required: false
    argument :url_contains, String, required: false
  end

  option :filter, type: LinkFilter, with: :apply_filter
  option :first, type: types.Int, with: :apply_first
  option :skip, type: types.Int, with: :apply_skip

  def apply_filter(scope, value)
    branches = normalize_filters(value).reduce { |a, b| a.or(b) }
    scope.merge branches
  end

  def normalize_filters(value, branches = [])
    scope = Link.all
    scope = scope.where('description LIKE ?', "%#{value[:description_contains]}%") if value[:description_contains]
    scope = scope.where('url LIKE ?', "%#{value[:url_contains]}%") if value[:url_contains]

    branches << scope

    value[:OR].reduce(branches) { |s, v| normalize_filters(v, s) } if value[:OR].present?

    branches
  end

  def apply_first(scope, value)
    scope.limit(value)
  end

  def apply_skip(scope, value)
    scope.offset(value)
  end
end
