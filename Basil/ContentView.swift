import SwiftUI
import RecipeList
import ComposableArchitecture

struct ContentView: View {
  var body: some View {
    RecipeListView(
      store: StoreOf<RecipeListFeature>(
        initialState: RecipeListFeature.State(),
        reducer: { RecipeListFeature() }
      )
    )
  }
}

#Preview {
  ContentView()
}
