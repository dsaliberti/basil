import SwiftUI

public struct RecipeTagsView: View {
  
  let tags: [String]
  
  public init(tags: [String]) {
    self.tags = tags
  }
  
  public var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 4) {
        ForEach(tags, id: \.self) { tag in
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
  RecipeTagsView(tags: ["Spicy", "Vegetarian", "Quick"])
}