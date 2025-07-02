import Core
import Testing
import SharedModels
import RecipeDetail
import ComposableArchitecture

@testable import RecipeList

struct RecipeListTests {
  
  @Test func task_success_populatesResult() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    ) {
      $0.restAPIClient.fetchAllRecipes = { .mock }
    }
    
    await store.send(.task) {
      $0.status = .loading
    }
    
    await store.receive(\.recipesUdpated) {
      $0.status = .loaded
      $0.recipes = .mock
    }
  }
  
  @Test func task_failure_throwsError() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    ) {
      $0.restAPIClient.fetchAllRecipes = { throw RestAPIError.failedToFetch }
    }
    
    await store.send(.task) {
      $0.status = .loading
    }
    
    await store.receive(\.recipesLoadFailed) {
      $0.status = .failure("Failed to load recipes.\nPlease try again later.")
    }
  }
  
  @Test func task_emptyRecipesResult() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    )
    
    await store.send(.task) {
      $0.status = .loading
    }
    
    await store.receive(\.recipesUdpated) {
      $0.status = .empty("No recipes found")
    }
  }
  
  @Test func didTapRow_navigatesToRecipeDetail() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    )
    
    await store.send(.didTapRow(.mock)) {
      $0.destination = .detail(RecipeDetailFeature.State(recipe: .mock))
    }
  }
  
  @Test func didTapFilter_navigatesToFilterOptions() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    )
    
    await store.send(.didTapFilter) {
      $0.destination = .filterOptions(FilterOptionsFeature.State())
    }
  }
  
  @Test func filters_shouldFilter_filteredRecipes() async throws {
    
    @Shared(.selectedFilters) var filters: FilterOptions = FilterOptions(
      difficulty: .medium,
      rating: .fourPlus
    )
    
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    ) {
      $0.restAPIClient.fetchAllRecipes = { .mockToFilter }
    }
    
    await store.send(.task) {
      $0.status = .loading
    }
    
    await store.receive( \.recipesUdpated) {
      $0.recipes = .mockToFilter
      $0.status = .loaded
      
      #expect( Set($0.filteredRecipes.map(\.difficulty)) == [.medium]  )
      
      #expect( Set($0.filteredRecipes.map(\.rating).map(Rating.init(rawValue:))) == [.fourPlus]  )
    }
  }
  
  @Test func didPullToRefresh_shouldFetchRecipeList() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    ) {
      $0.restAPIClient.fetchAllRecipes = { .mock }
    }
    
    await store.send(.didPullToRefresh) {
      $0.status = .loading
    }
    
    await store.receive(\.recipesUdpated) {
      $0.recipes = .mock
      $0.status = .loaded
    }
  }
  
  @Test func emptyFiltersResult_didTapClearAllFilters_shouldResetFiltersAndStatusLoaded() async throws {
    
    @Shared(.selectedFilters) var filters: FilterOptions = FilterOptions(
      difficulty: .medium,
      rating: .fourPlus
    )
    
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    ) {
      $0.restAPIClient.fetchAllRecipes = { .mock }
    }
    
    await store.send(.task) {
      $0.status = .loading
    }
    
    await store.receive(\.recipesUdpated) {
      $0.recipes = .mock
      $0.status = .emptyFiltersResult("No recipes found matching your filters")
    }
    
    await store.send(.didTapClearFilters) {
      $0.$filters.withLock {
        $0.difficulty = .all
        $0.rating = .all
      }
      
      $0.status = .loaded
    }
  }
}
