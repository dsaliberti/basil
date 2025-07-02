import Core
import Testing
import SharedModels
import ComposableArchitecture

@testable import RecipeDetail

struct RecipeDetailTests {
  
  @Test func didFavorite_shouldToggleFavorite() async throws {
    
    @Shared(.favoriteRecipeIds) var favorites: Set<Recipe.ID> = []
    
    let store = await TestStoreOf<RecipeDetailFeature>(
      initialState: RecipeDetailFeature.State(recipe: .mock),
      reducer: { RecipeDetailFeature() }
    )
    
    await store.send(.didTapFavorite(1)) {
      $0.$favorites.withLock {
        $0 = [1]
      }
    }
    
    await store.send(.didTapFavorite(1)) {
      $0.$favorites.withLock {
        $0 = []
      }
    }
  }
}
