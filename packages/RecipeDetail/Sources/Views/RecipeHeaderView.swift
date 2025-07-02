import SwiftUI
import Foundation
import Kingfisher

public struct RecipeHeaderView: View {
  let name: String
  let imageURL: URL?
  
  public init(
    name: String,
    imageURL: URL?
  ) {
    self.name = name
    self.imageURL = imageURL
  }
  
  public var body: some View {
    KFImage(imageURL)
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
        Text(name)
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
}

#Preview {
  VStack {
    
    
    RecipeHeaderView(
      name: "Recipe Name",
      imageURL: URL(
        string: "https://cdn.dummyjson.com/recipe-images/2.webp"
      )
    )
    .frame(maxWidth: .infinity)
  }
}
