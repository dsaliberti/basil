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
  
  public enum RestAPIError: Error { case failedToFetch }
  
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
      .mock
    ]
  }
}
