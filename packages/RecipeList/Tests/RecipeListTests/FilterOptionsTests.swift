import Core
import Testing
import SharedModels
import ComposableArchitecture

@testable import RecipeList

struct FilterOptionsTests {
  
  @Test func didTapCancel_shouldCallDismiss() async throws {
    
    let isDismissCalled = LockIsolated(false)
    
    let store = await TestStoreOf<FilterOptionsFeature>(
      initialState: FilterOptionsFeature.State(),
      reducer: { FilterOptionsFeature() }
    ) {
      $0.dismiss = DismissEffect {
        isDismissCalled.setValue(true)
      }
    }
    
    await store.send(.didTapCancel)
    
    #expect(isDismissCalled.value)
  }
  
  @Test func updateSelectedValues_didTapConfirm_shouldSaveFiltersAndDismiss() async throws {
    
    let isDismissCalled = LockIsolated(false)
    
    let store = await TestStoreOf<FilterOptionsFeature>(
      initialState: FilterOptionsFeature.State(),
      reducer: { FilterOptionsFeature() }
    ) {
      $0.dismiss = DismissEffect {
        isDismissCalled.setValue(true)
      }
    }
    
    await store.send(.didSelectDifficulty(.easy)) {
      $0.selectedDifficulty = .easy
    }
    
    await store.send(.didSelectRating(.fourPlus)) {
      $0.selectedRating = .fourPlus
    }
    
    await store.send(.didTapConfirm) {
      $0.$filters.withLock {
        $0.difficulty = .easy
        $0.rating = .fourPlus
      }
    }
    
    #expect(isDismissCalled.value)
  }
}
