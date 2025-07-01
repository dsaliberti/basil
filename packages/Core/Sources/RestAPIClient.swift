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

public enum RestAPIError: Error { case failedToFetch }

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

public extension Array where Element == Recipe {
  static var mock: Self {
    [
      .mock
    ]
  }
  
  static var mockToFilter: Self {
    [
      .init(id: 1, difficulty: .easy, rating: 3.0),
      .init(id: 2, difficulty: .medium, rating: 4.3),
      .init(id: 3, difficulty: .hard, rating: 4.5),
      .init(id: 4, difficulty: .easy, rating: 4.7),
      .init(id: 5, difficulty: .medium, rating: 4.9),
      .init(id: 6, difficulty: .hard, rating: 5.0),
    ]
  }
}

extension Recipe {
  init(
    id: Int,
    difficulty: Difficulty,
    rating: Double
  ) {
    self = Recipe(
      id: id,
      name: "Generic",
      ingredients: ["Generic"],
      instructions: ["Generic"],
      prepTimeMinutes: 33,
      cookTimeMinutes: 33,
      servings: 33,
      difficulty: difficulty,
      cuisine: "Generic",
      caloriesPerServing: 33,
      tags: ["Generic"],
      userId: 33,
      image: "Generic",
      rating: rating,
      reviewCount: 33,
      mealType: ["Generic"]
    )
  }
}
