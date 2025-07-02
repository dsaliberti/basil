import Core
import SwiftUI
import Kingfisher
import SharedModels
import RecipeDetail
import ComposableArchitecture

public struct RecipeListView: View {
  
  @Bindable var store: StoreOf<RecipeListFeature>
  
  public init(store: StoreOf<RecipeListFeature>) {
    self.store = store
  }
  
  public var body: some View {
    
    NavigationStack {
      VStack {
        Section {
          switch store.status {
          case .initial, .loading:
            progressView
            
          case .loaded:
            recipesList
            
          case let .failure(message),
            let .empty(message),
            let .emptyFiltersResult(message):
            unavailableView(message)
          }
        }
      }
      .navigationTitle(store.title)
      .toolbar {
        if !store.recipes.isEmpty {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              store.send(.didTapFilter)
            } label: {
              Image(systemName: "line.3.horizontal.decrease.circle")
            }
          }
        }
      }
      .sheet(
        item: $store.scope(
          state: \.destination?.filterOptions,
          action: \.destination.filterOptions
        )
      ) { store in
        FilterOptionsView(store: store)
          .presentationDetents([.medium])
      }
      .navigationDestination(
        item: $store.scope(
          state: \.destination?.detail,
          action: \.destination.detail
        )
      ) {
        RecipeDetailView(store: $0)
      }
    }
    .task {
      await store.send(.task).finish()
    }
  }
  
  private var recipesList: some View {
    List(store.filteredRecipes) { recipe in
      Button {
        store.send(.didTapRow(recipe))
      } label: {
        RecipeRowView(recipe: recipe)
          .overlay(alignment: .trailing) {
            if store.favorites.contains(recipe.id) {
              Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25)
                .foregroundStyle(.yellow)
            }
          }
      }
      .foregroundStyle(.primary)
    }
  }
  
  private func unavailableView(_ message: String) -> some View {
    ScrollView {
      ContentUnavailableView(
        message,
        systemImage: "icloud.slash"
      )
      .foregroundStyle(.gray)
      
      if case .emptyFiltersResult = store.status {
        Button {
          store.send(.didTapClearFilters)
        } label: {
          Text("Clear filters")
        }
        .buttonStyle(BorderedButtonStyle())
      }
    }
    .refreshable {
      store.send(.didPullToRefresh)
    }
  }
  
  private var progressView: some View {
    ScrollView {
      ProgressView()
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }
  }
}

#Preview("Loaded List") {
  RecipeListView(
    store: StoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: {
        RecipeListFeature()
      }
    )
  )
}

#Preview("Empty List") {
  RecipeListView(
    store: StoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(
        status: .empty("No recipes found")
      ),
      reducer: { RecipeListFeature() }
    )
  )
}

#Preview("Empty by filters") {
  
  @Shared(.selectedFilters) var filters: FilterOptions = FilterOptions(difficulty: .hard)
  
  RecipeListView(
    store: StoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(
        
      ),
      reducer: { RecipeListFeature() }
    )
  )
}


#Preview("Failure loading List") {
  RecipeListView(
    store: StoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(
        status: .failure("Failed to load recipes.\nPlease try again later.")
      ),
      reducer: { RecipeListFeature() }
    )
  )
}

#Preview("Loading") {
  RecipeListView(
    store: StoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(
        status: .loading
      ),
      reducer: { RecipeListFeature() }
    )
  )
}

#Preview("Loading, then loaded") {
  RecipeListView(
    store: StoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: {
        RecipeListFeature()
          .dependency(
            \.restAPIClient.fetchAllRecipes, {
              try? await Task.sleep(for: .seconds(3))
              
              return .mock
            }
          )
      }
    )
  )
}

#Preview("Loading, then failure") {
  RecipeListView(
    store: StoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: {
        RecipeListFeature()
          .dependency(
            \.restAPIClient.fetchAllRecipes, {
              try? await Task.sleep(for: .seconds(3))
              
              throw RestAPIError.failedToFetch
            }
          )
      }
    )
  )
}

#Preview("Loading, then empty") {
  RecipeListView(
    store: StoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: {
        RecipeListFeature()
          .dependency(
            \.restAPIClient.fetchAllRecipes, {
              try? await Task.sleep(for: .seconds(3))
              
              return []
            }
          )
      }
    )
  )
}
