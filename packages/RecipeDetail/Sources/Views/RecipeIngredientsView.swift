import SwiftUI

public struct RecipeIngredientsView: View {
  
  let ingredients: [String]
  
  public init(ingredients: [String]) {
    self.ingredients = ingredients
  }
  
  public var body: some View {
    Section(header: Text("**Ingredients:**")) {
      ForEach(ingredients, id: \.self) { ingredient in
        Text("- \(ingredient)")
          .font(.body)
          .padding(.vertical, 4)
      }
    }
  }
}
