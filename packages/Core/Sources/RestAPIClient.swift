import SharedModels
import ComposableArchitecture

public struct RestAPIClient: Sendable {
  ///
  public var fetchAllRecipes: @Sendable () async throws -> [Recipe]
  
  public init(
    fetchAllRecipes: @escaping @Sendable () async throws -> [Recipe]
  ) {
    self.fetchAllRecipes = fetchAllRecipes
  }
}

extension RestAPIClient: TestDependencyKey {
  public static var testValue: RestAPIClient {
    Self(
      fetchAllRecipes: { [] }
    )
  }
  
  public static var previewValue: RestAPIClient {
    Self(
      fetchAllRecipes: { .mock }
    )
  }
  
}

extension DependencyValues {
  public var restAPIClient: RestAPIClient {
    get { self[RestAPIClient.self] }
    set { self[RestAPIClient.self] = newValue }
  }
}

extension Array where Element == Recipe {
  static var mock: Self {
    [
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
        difficulty: "Easy",
        cuisine: "Italian",
        caloriesPerServing: 300,
        tags: ["Pizza", "Italian"],
        userId: 166,
        image: "https://cdn.dummyjson.com/recipe-images/1.webp",
        rating: 4.6,
        reviewCount: 98,
        mealType: ["Dinner"]
      )
    ]
  }
}
