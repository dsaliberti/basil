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
        
        KFImage(store.recipe.imageURL)
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
        
        Group {
          
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
          
          Divider()
          
          Section(header: Text("**Ingredients:**")) {
            ForEach(store.recipe.ingredients, id: \.self) { ingredient in
              Text("- \(ingredient)")
                .font(.body)
                .padding(.vertical, 4)
            }
          }
          
          Divider()
          
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
        .padding(.horizontal)
        
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
