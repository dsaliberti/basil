import SharedModels
import ComposableArchitecture

@Reducer
public struct RecipeListFeature: Sendable {
  
  @Dependency(\.restAPIClient) var restAPIClient
  
  public init() {}
  
  
  @ObservableState
  public struct State: Equatable {
    let title = "Recipes"
    
    var recipes: [Recipe] = []
    
    public init(recipes: [Recipe] = []) {
      self.recipes = recipes
    }
  }
  
  public enum Action {
    case task
    case recipesUdpated([Recipe])
  }
  
  public var body: some Reducer<State, Action> {
    Reduce(self.core)
  }
  
  func core(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .task:
      return .run { send in
        do {
          await send(.recipesUdpated(try await restAPIClient.fetchAllRecipes()))
          
        } catch {
          print(error)
        }
      }
      
    case let .recipesUdpated(recipes):
      state.recipes = recipes
      return .none
      
    }
  }
}
