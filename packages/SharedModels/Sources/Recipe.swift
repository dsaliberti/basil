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

public extension Recipe {
  static var mock: Recipe {
    Recipe(
      id: 1,
      name: "Classic Margherita Pizza",
      ingredients: [
          "Pizza dough",
          "Tomato sauce",
          "Fresh mozzarella cheese",
          "Fresh basil leaves",
          "Olive oil",
          "Salt and pepper to taste"
      ],
      instructions: [
        "Preheat the oven to 475°F (245°C).",
        "Roll out the pizza dough and spread tomato sauce evenly.",
        "Top with slices of fresh mozzarella and fresh basil leaves.",
        "Drizzle with olive oil and season with salt and pepper.",
        "Bake in the preheated oven for 12-15 minutes or until the crust is golden brown.",
        "Slice and serve hot."
      ],
      prepTimeMinutes: 20,
      cookTimeMinutes: 15,
      servings: 4,
      difficulty: .easy,
      cuisine: "Italian",
      caloriesPerServing: 300,
      tags: [
        "Pizza",
        "Italian",
        "Vegetarian",
        "Quick",
        "Dessert",
        "Healthy",
        "Vegan",
        "Gluten-free",
        "Low-carb",
        "Spicy",
        "Sweet",
        "Savory",
        "Quick",
        "Easy"
      ],
      userId: 166,
      image: "https://cdn.dummyjson.com/recipe-images/1.webp",
      rating: 4.6,
      reviewCount: 98,
      mealType: ["Dinner"]
    )
  }
}
