import Foundation

public struct Recipe: Identifiable, Decodable, Sendable {
  public let id: Int
  public let name: String
  public let ingredients: [String]
  public let instructions: [String]
  public let prepTimeMinutes: Int
  public let cookTimeMinutes: Int
  public let servings: Int
  public let difficulty: String
  public let cuisine: String
  public let caloriesPerServing: Int
  public let tags: [String]
  public let userId: Int
  public let image: String
  public var imageURL: URL? { URL(string: image) }
  public let rating: Double
  public let reviewCount: Int
  public let mealType: [String]
}
