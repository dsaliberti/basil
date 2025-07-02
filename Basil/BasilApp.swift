import SwiftUI
import RecipeList
import ComposableArchitecture

@main
struct BasilApp: App {
  var body: some Scene {
    WindowGroup {
      RecipeListView(
        store: StoreOf<RecipeListFeature>(
          initialState: RecipeListFeature.State(),
          reducer: { RecipeListFeature() }
        )
      )
    }
  }
}
