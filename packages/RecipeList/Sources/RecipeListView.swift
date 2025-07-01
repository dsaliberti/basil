import Core
import SwiftUI
import Kingfisher
import RecipeDetail
import ComposableArchitecture

public struct RecipeListView: View {
  
  @Bindable var store: StoreOf<RecipeListFeature>
  
  @Namespace var animation
  
  public init(store: StoreOf<RecipeListFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      VStack {
        Section {
          
          if store.recipes.isEmpty {
            if let errorMessage = store.errorMessage {
              ScrollView {
                ContentUnavailableView(
                  errorMessage,
                  systemImage: "icloud.slash"
                )
                .foregroundStyle(.gray)
              }
              .refreshable {
                store.send(.didPullToRefresh)
              }
            }
          } else {
            List(store.filteredRecipes, id: \.id) { recipe in
              Button {
                store.send(.didTapRow(recipe))
              } label: {
                RecipeRowView(recipe: recipe)
              }
              .buttonStyle(PlainButtonStyle())
              
            }
          }
        }
      }
      .navigationTitle(Text(store.title))
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
}

#Preview {
  RecipeListView(
    store: StoreOf<RecipeListFeature>(
      initialState: RecipeListFeature.State(),
      reducer: { RecipeListFeature() }
    )
  )
}
