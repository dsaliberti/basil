import Core
import SwiftUI
import SharedModels
import ComposableArchitecture

struct ContentView: View {
  @State private var names: [String] = []
  @Dependency(\.restAPIClient) var restAPIClient
  var body: some View {
    
    Section(header: Text("Recipes")) {
      List(names, id: \.self) { name in
        Text(name)
      }
    }
    .task {
      do {
        let recipes = try await restAPIClient.fetchAllRecipes()
        self.names = recipes.map(\.name)
      } catch {
        print(error)
      }
    }
  }
}

#Preview {
  ContentView()
}
