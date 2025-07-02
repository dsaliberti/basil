import Core
import SharedModels
import ComposableArchitecture

@Reducer
public struct RecipeDetailFeature: Sendable {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    let recipe: Recipe
    
    @Shared(.favoriteRecipeIds) var favorites: Set<Recipe.ID> = []
    
    public init(recipe: Recipe) {
      self.recipe = recipe
    }
  }
  
  public enum Action {
    case didTapFavorite(Recipe.ID)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce(self.core)
  }
  
  func core(state: inout State, action: Action) -> Effect<Action> {
    switch action {
      
    case let .didTapFavorite(id):
      if state.favorites.contains(id) {
        let _ = state.$favorites.withLock { $0.remove(id) }
      } else {
        let _ = state.$favorites.withLock { $0.insert(id) }
      }
      
      return .none
    }
  }
}
