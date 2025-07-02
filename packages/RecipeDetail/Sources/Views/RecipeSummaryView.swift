import SwiftUI
import Foundation

public struct RecipeSummaryView: View {
  let prepTimeMinutes: Int
  let cookTimeMinutes: Int
  let caloriesPerServing: Int
  let cuisine: String
  
  public init(
    prepTimeMinutes: Int,
    cookTimeMinutes: Int,
    caloriesPerServing: Int,
    cuisine: String
  ) {
    self.prepTimeMinutes = prepTimeMinutes
    self.cookTimeMinutes = cookTimeMinutes
    self.caloriesPerServing = caloriesPerServing
    self.cuisine = cuisine
  }
  
  public var body: some View {
    LazyHGrid(rows: [GridItem(.flexible())]) {
      Image(systemName: "timer")
      Text("**\(prepTimeMinutes)**min")
      
      Divider()
      
      Image(systemName: "oven")
      Text("**\(cookTimeMinutes)**min")
      
      Divider()
      
      Image(systemName: "flame")
      Text("**\(caloriesPerServing)**cal")
      
      Divider()
      Image(systemName: "map")
      Text(cuisine)
        .frame(maxWidth: 90)
    }
    .font(.caption)
    .truncationMode(.tail)
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  RecipeSummaryView(
    prepTimeMinutes: 33,
    cookTimeMinutes: 33,
    caloriesPerServing: 33,
    cuisine: "Italian"
  )
  .frame(height: 50)
}
