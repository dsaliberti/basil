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
}

extension DependencyValues {
  public var restAPIClient: RestAPIClient {
    get { self[RestAPIClient.self] }
    set { self[RestAPIClient.self] = newValue }
  }
}
