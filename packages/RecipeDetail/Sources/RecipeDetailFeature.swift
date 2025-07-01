import SharedModels
import ComposableArchitecture

@Reducer
public struct RecipeDetailFeature: Sendable {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    let recipe: Recipe
    
    public init(recipe: Recipe) {
      self.recipe = recipe
    }
  }
  
  public enum Action {
    case didTapDismiss
  }
  
  public var body: some Reducer<State, Action> {
    Reduce(self.core)
  }
  
  func core(state: inout State, action: Action) -> Effect<Action> {
    switch action {
      
    case .didTapDismiss:
      @Dependency(\.dismiss) var dismiss
      return .run { _ in
        await dismiss()
      }
    }
  }
}
