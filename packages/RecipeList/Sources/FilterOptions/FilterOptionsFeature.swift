import SharedModels
import ComposableArchitecture

public struct FilterOptions: Sendable, Equatable {
  public var difficulty: Difficulty = .all
  public var rating: Rating = .all
}

@Reducer
public struct FilterOptionsFeature: Sendable {
  
  @Dependency(\.dismiss) var dismiss
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    
    public var selectedDifficulty: Difficulty
    
    public var selectedRating: Rating
    
    @Shared(.inMemory("filters")) var filters: FilterOptions = FilterOptions()
    
    public init(
      selectedDifficulty: Difficulty = .all,
      selectedRating: Rating = .all
    ) {
      self.selectedDifficulty = selectedDifficulty
      self.selectedRating = selectedRating
    }
  }
  
  @CasePathable
  public enum Action {
    case didSelectDifficulty(Difficulty)
    case didSelectRating(Rating)
    case didTapCancel
    case didTapConfirm
  }
  
  public var body: some Reducer<State, Action> {
    Reduce(self.core)
  }
  
  func core(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case let .didSelectDifficulty(difficulty):
      state.selectedDifficulty = difficulty
      return .none
    
    case let .didSelectRating(rating):
      state.selectedRating = rating
      return .none
      
    case .didTapCancel:
      return .run { _ in
        await dismiss()
      }
      
    case .didTapConfirm:
      state.$filters.withLock {
        $0.difficulty = state.selectedDifficulty
        $0.rating = state.selectedRating
      }
      
      return .run { _ in
        await dismiss()
      }
    }
  }
}
