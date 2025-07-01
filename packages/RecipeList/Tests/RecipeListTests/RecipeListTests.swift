import Core
import Testing
import SharedModels
import RecipeDetail
import ComposableArchitecture

@testable import RecipeList

struct RecipeListTests {
  
  @Test func task_successPopulateResult() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    ) {
      $0.restAPIClient.fetchAllRecipes = { .mock }
    }
    
    await store.send(.task)
    
    await store.receive(\.recipesUdpated) {
      $0.recipes = .mock
    }
  }
  
  @Test func task_failureThrowsError() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    ) {
      $0.restAPIClient.fetchAllRecipes = { throw RestAPIError.failedToFetch }
    }
    
    await store.send(.task)
    
    await store.receive(\.recipesLoadFailed) {
      $0.errorMessage = "Failed to load recipes.\nPlease try again later."
    }
  }
  
  @Test func task_emptyRecipesResult() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    )
    
    await store.send(.task)
    await store.receive(\.recipesUdpated)
  }
  
  @Test func didTapRow_navigateToRecipeDetail() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    )
    
    await store.send(.didTapRow(.mock)) {
      $0.destination = .detail(RecipeDetailFeature.State(recipe: .mock))
    }
  }
  
  @Test func didTapFilter_navigateToFilterOptions() async throws {
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    )
    
    await store.send(.didTapFilter) {
      $0.destination = .filterOptions(FilterOptionsFeature.State())
    }
  }
  
  @Test func filters_shouldFilter_filteredRecipes() async throws {
    
    @Shared(.inMemory("filters")) var filters: FilterOptions = FilterOptions(
      difficulty: .medium,
      rating: .fourPlus
    )
    
    let store = await TestStoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    ) {
      $0.restAPIClient.fetchAllRecipes = { .mockToFilter }
    }
    
    await store.send(.task)
    
    await store.receive( \.recipesUdpated) {
      $0.recipes = .mockToFilter
      
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
    
    await store.send(.didPullToRefresh)
    
    await store.receive(\.recipesUdpated) {
      $0.recipes = .mock
    }
  }
}
