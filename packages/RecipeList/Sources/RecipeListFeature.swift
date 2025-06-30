import SharedModels
import ComposableArchitecture

@Reducer
public struct RecipeListFeature: Sendable {
  
  @Dependency(\.restAPIClient) var restAPIClient
  
  public init() {}
  
  @Reducer(state: .equatable)
  public enum Destination {
    case filterOptions(FilterOptionsFeature)
  }
  
  @ObservableState
  public struct State: Equatable {
    var title: String {
      "Recipes (\(filteredRecipes.count))"
    }
    
    var recipes: [Recipe] = []
    
    var errorMessage: String? = nil
    
    @Presents var destination: Destination.State?
    
    @Shared(.inMemory("filters")) var filters: FilterOptions = FilterOptions()
    
    var filteredRecipes: [Recipe] {
        recipes.filter {
          let difficulty = filters.difficulty == .all || $0.difficulty == filters.difficulty
          let rating = filters.rating == .all || $0.rating >= filters.rating.rawValue
          
          return difficulty && rating
        }
    }
    
    public init(recipes: [Recipe] = []) {
      self.recipes = recipes
    }
  }
  
  public enum Action {
    case task
    case recipesUdpated([Recipe])
    case recipesLoadFailed
    case didTapFilter
    case destination(PresentationAction<Destination.Action>)
    case didPullToRefresh
  }
  
  public var body: some Reducer<State, Action> {
    Reduce(self.core)
      .ifLet(\.$destination, action: \.destination)
  }
  
  func core(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .task:
      return fetchRecipes()
      
    case .didPullToRefresh:
      return fetchRecipes()
      
    case let .recipesUdpated(recipes):
      
      let ratings = Set(recipes.map(\.rating))
      
      state.recipes = recipes
      return .none
      
    case .recipesLoadFailed:
      state.errorMessage = "Failed to load recipes.\nPlease try again later."
      return .none
      
    case .didTapFilter:
      state.destination = .filterOptions(
        FilterOptionsFeature.State(
          selectedDifficulty: state.filters.difficulty,
          selectedRating: state.filters.rating
        )
      )
      return .none
      
    case .destination:
      return .none
    }
  }
  
  private func fetchRecipes() -> Effect<Action> {
    
    return .run { send in
      do {
        await send(.recipesUdpated(try await restAPIClient.fetchAllRecipes()))
        
      } catch {
        print(error)
        await send(.recipesLoadFailed)
      }
    }
  }
}
