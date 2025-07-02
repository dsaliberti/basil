import SwiftUI
import Kingfisher
import SharedModels
import ComposableArchitecture

public struct RecipeDetailView: View {
  
  let store: StoreOf<RecipeDetailFeature>
  
  public init(store: StoreOf<RecipeDetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        
        RecipeHeaderView(
          name: store.recipe.name,
          imageURL: store.recipe.imageURL
        )
        
        Group {
          
          RecipeSummaryView(
            prepTimeMinutes: store.recipe.prepTimeMinutes,
            cookTimeMinutes: store.recipe.cookTimeMinutes,
            caloriesPerServing: store.recipe.caloriesPerServing,
            cuisine: store.recipe.cuisine
          )
          
          Divider()
          
          RecipeIngredientsView(ingredients: store.recipe.ingredients)
          
          Divider()
          
          RecipeInstructionsView(instructions: store.recipe.instructions)
        }
        .padding(.horizontal)
        
        RecipeTagsView(tags: store.recipe.tags)
        
        RecipeFavoriteButton(isFavorite: store.favorites.contains(store.recipe.id)) {
          store.send(.didTapFavorite(store.recipe.id))
        }
      }
      .padding(.bottom, 64)
      
    }
    .toolbarBackground(.visible, for: .navigationBar)
    .listStyle(PlainListStyle())
    .ignoresSafeArea(edges: [.top])
  }
}

#Preview {
  @Previewable @State var isPresented = true
  
  NavigationStack {
    Button {
      isPresented.toggle()
    } label: {
      Text("Present")
    }
    
    .navigationDestination(
      isPresented: $isPresented
    ) {
      RecipeDetailView(
        store: StoreOf<RecipeDetailFeature>(
          initialState: RecipeDetailFeature.State(
            recipe: .mock
          ),
          reducer: { RecipeDetailFeature() }
        )
      )
      .presentationDetents([.large])
    }
  }
}
