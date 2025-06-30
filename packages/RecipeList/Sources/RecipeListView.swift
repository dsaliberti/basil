import Core
import Kingfisher
import SwiftUI
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
            List(store.filteredRecipes) { recipe in
              HStack(spacing: 8) {
                KFImage(recipe.imageURL)
                  .resizable()
                  .placeholder { progress in
                    ProgressView(value: progress.fractionCompleted)
                      .padding()
                      .frame(maxWidth: .infinity, maxHeight: .infinity)
                      .background(.black.opacity(0.1))
                  }
                  .onFailure { error in
                    print(error)
                  }
                  .cacheMemoryOnly(true)
                  .frame(width: 90, height: 90)
                  .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                  Text(recipe.name)
                    .font(.headline)
                  
                  Text("difficulty: **\(recipe.difficulty.rawValue)**")
                    .font(.subheadline)
                  
                  Text("rating: **\(recipe.rating, format: .number)**")
                    .font(.subheadline)
                }
              }
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
