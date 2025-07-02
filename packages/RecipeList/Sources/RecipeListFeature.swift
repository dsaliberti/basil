import SharedModels
import RecipeDetail
import ComposableArchitecture

@Reducer
public struct RecipeListFeature: Sendable {
  
  @Dependency(\.restAPIClient) var restAPIClient
  
  public init() {}
  
  @Reducer(state: .equatable)
  public enum Destination {
    case filterOptions(FilterOptionsFeature)
    case detail(RecipeDetailFeature)
  }
  
  @ObservableState
  public struct State: Equatable {
    var title: String {
      "Recipes (\(filteredRecipes.count))"
    }
    
    var recipes: [Recipe] = []
    
    var status: Status = .initial
    
    public enum Status: Equatable {
      case initial
      case loading
      case loaded
      case failure(String)
      case empty(String)
      case emptyByFilters(String)
    }
    
    @Presents var destination: Destination.State?
    
    @Shared(.inMemory("filters")) var filters: FilterOptions = FilterOptions()
    
    var filteredRecipes: [Recipe] {
        recipes.filter {
          let difficulty = filters.difficulty == .all || $0.difficulty == filters.difficulty
          let rating = filters.rating == .all || $0.rating >= filters.rating.rawValue
          
          return difficulty && rating
        }
    }
    
    public init(
      recipes: [Recipe] = [],
      status: Status = .initial,
      destination: Destination.State? = nil
    ) {
      self.recipes = recipes
      self.status = status
      self.destination = destination
    }
  }
  
  public enum Action {
    case task
    case recipesUdpated([Recipe])
    case recipesLoadFailed
    case didTapFilter
    case destination(PresentationAction<Destination.Action>)
    case didPullToRefresh
    case didTapRow(Recipe)
    case didTapClearFilters
  }
  
  public var body: some Reducer<State, Action> {
    Reduce(self.core)
      .ifLet(\.$destination, action: \.destination)
  }
  
  func core(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .task:
      guard state.status == .initial else { return .none }
      
      return fetchRecipes(state: &state)
      
    case .didPullToRefresh:
      return fetchRecipes(state: &state)
      
    case let .recipesUdpated(recipes):
      state.recipes = recipes
      return updateStatus(state: &state)
      
    case .recipesLoadFailed:
      state.status = .failure("Failed to load recipes.\nPlease try again later.")
      return .none
      
    case .didTapFilter:
      state.destination = .filterOptions(
        FilterOptionsFeature.State(
          selectedDifficulty: state.filters.difficulty,
          selectedRating: state.filters.rating
        )
      )
      return .none
     
    case .destination(.presented(.filterOptions(.didTapConfirm))):
      return updateStatus(state: &state)
      
    case .destination:
      return .none
      
    case let .didTapRow(recipe):
      state.destination = .detail(RecipeDetailFeature.State(recipe: recipe))
      return .none
      
    case .didTapClearFilters:
      state.$filters.withLock {
        $0.difficulty = .all
        $0.rating = .all
      }
      
      return updateStatus(state: &state)
    }
  }
  
  private func updateStatus(state: inout State) -> Effect<Action> {
    guard !state.recipes.isEmpty else {
      state.status = .empty("No recipes found")
      return .none
    }
    
    if state.filteredRecipes.isEmpty {
      state.status = .emptyByFilters("No recipes found matching your filters")
    } else {
      state.status = .loaded
    }
    
    return .none
  }
  
  private func fetchRecipes(state: inout State) -> Effect<Action> {
    state.status = .loading
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
