import SwiftUI
import Kingfisher
import SharedModels

struct RecipeRowView: View {
  let recipe: Recipe
  
  var body: some View {
    HStack(spacing: 8) {
      KFImage(recipe.imageURL)
        .resizable()
        .placeholder { progress in
          ProgressView(value: progress.fractionCompleted)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black.opacity(0.1))
        }
        .frame(width: 90, height: 90)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      
      VStack(alignment: .leading, spacing: 4) {
        Group {
          Text(recipe.name)
            .font(.headline)
          
          Text("difficulty: **\(recipe.difficulty.rawValue)**")
            .font(.subheadline)
          
          Text("rating: **\(recipe.rating, format: .number)**")
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}

#Preview {
  RecipeRowView(recipe: .mock)
}
