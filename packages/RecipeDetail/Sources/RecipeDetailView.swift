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
        
        headerView

        Group {
          summaryView
          Divider()
          ingredientsView
          Divider()
          instructionsView
        }
        .padding(.horizontal)
        
        tagsView
        
        favoriteButtonView
        
      }
      .padding(.bottom, 64)
      
    }
    .toolbarBackground(.visible, for: .navigationBar)
    .ignoresSafeArea(edges: [.top])
  }
}

extension RecipeDetailView {
  
  private var headerView: some View {
    KFImage(store.recipe.imageURL)
      .resizable()
      .placeholder { progress in
        ProgressView(value: progress.fractionCompleted)
          .padding()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(.black.opacity(0.1))
      }
      .frame(height: 400)
      .aspectRatio(contentMode: .fill)
      .frame(maxWidth: .infinity)
      .overlay(alignment: .bottom) {
        Text(store.recipe.name)
          .font(.title)
          .bold(true)
          .padding()
          .frame(
            maxWidth: .infinity,
            alignment: .leading
          )
          .background(.ultraThinMaterial)
          .lineLimit(4)
      }
  }
  
  private var favoriteButtonView: some View {
    Button {
      store.send(.didTapFavorite(store.recipe.id))
    } label: {
      HStack {
        Text("Favorite")
          
        if store.favorites.contains(store.recipe.id) {
          Image(systemName: "star.fill")
            .foregroundStyle(.yellow)
        } else {
          Image(systemName: "star")
        }
      }
    }
    .font(.title2)
    .buttonStyle(BorderedButtonStyle())
    .tint(.secondary)
    .frame(maxWidth: .infinity)
  }
  
  private var summaryView: some View {
    LazyHGrid(rows: [GridItem(.flexible())]) {
      Image(systemName: "timer")
      Text("**\(store.recipe.prepTimeMinutes)**min")
      
      Divider()
      
      Image(systemName: "oven")
      Text("**\(store.recipe.cookTimeMinutes)**min")
      
      Divider()
      
      Image(systemName: "flame")
      Text("**\(store.recipe.caloriesPerServing)**cal")
      
      Divider()
      Image(systemName: "map")
      Text(store.recipe.cuisine)
        .frame(maxWidth: 90)
    }
    .font(.caption)
    .truncationMode(.tail)
    .frame(maxWidth: .infinity)
  }
  
  private var ingredientsView: some View {
    Section(header: Text("**Ingredients:**")) {
      ForEach(store.recipe.ingredients, id: \.self) { ingredient in
        Text("- \(ingredient)")
          .font(.body)
          .padding(.vertical, 4)
      }
    }
  }
  
  private var instructionsView: some View {
    Section(header: Text("**Instructions:**")) {
      ForEach(
        Array(store.recipe.instructions.enumerated()),
        id: \.offset
      ) { index, instruction in
        Text("\(index + 1)) \(instruction)")
          .font(.body)
          .padding(.vertical, 4)
      }
    }
  }
  
  private var tagsView: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 4) {
        ForEach(store.recipe.tags, id: \.self) { tag in
          Text(tag)
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.secondary.opacity(0.2))
            .cornerRadius(8)
        }
      }
      .padding(.vertical)
    }
    .padding()
    
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
