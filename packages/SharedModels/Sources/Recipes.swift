public struct Recipes: Decodable {
  public let recipes: [Recipe]
  public let total: Int
  public let skip: Int
  public let limit: Int
}
