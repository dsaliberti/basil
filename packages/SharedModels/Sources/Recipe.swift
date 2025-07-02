import Foundation

public struct Recipe: Identifiable, Decodable, Sendable, Equatable {
  public let id: Int
  public let name: String
  public let ingredients: [String]
  public let instructions: [String]
  public let prepTimeMinutes: Int
  public let cookTimeMinutes: Int
  public let servings: Int
  public let difficulty: Difficulty
  public let cuisine: String
  public let caloriesPerServing: Int
  public let tags: [String]
  public let userId: Int
  public let image: String
  public var imageURL: URL? { URL(string: image) }
  public let rating: Double
  public let reviewCount: Int
  public let mealType: [String]
  
  public init(
    id: Int,
    name: String,
    ingredients: [String],
    instructions: [String],
    prepTimeMinutes: Int,
    cookTimeMinutes: Int,
    servings: Int,
    difficulty: Difficulty,
    cuisine: String,
    caloriesPerServing: Int,
    tags: [String],
    userId: Int,
    image: String,
    rating: Double,
    reviewCount: Int,
    mealType: [String]
  ) {
    self.id = id
    self.name = name
    self.ingredients = ingredients
    self.instructions = instructions
    self.prepTimeMinutes = prepTimeMinutes
    self.cookTimeMinutes = cookTimeMinutes
    self.servings = servings
    self.difficulty = difficulty
    self.cuisine = cuisine
    self.caloriesPerServing = caloriesPerServing
    self.tags = tags
    self.userId = userId
    self.image = image
    self.rating = rating
    self.reviewCount = reviewCount
    self.mealType = mealType
  }
}
