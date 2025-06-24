import SwiftUI

struct ContentView: View {
  @State private var names: [String] = []
  var body: some View {
    
    Section(header: Text("Recipes")) {
      List(names, id: \.self) { name in
        Text(name)
      }
    }
    
    .task {
      let url = URL(string: "https://dummyjson.com/recipes")!
      var request = URLRequest(url: url)
      
      do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let recipes = try decoder.decode(
          Recipes.self,
          from: data
        )
        
        self.names = recipes.recipes.map(\.name)
        
      } catch {
        print("~>", error.localizedDescription)
      }
    }
  }
}

#Preview {
  ContentView()
}

struct Recipes: Decodable {
  let recipes: [Recipe]
  let total: Int
  let skip: Int
  let limit: Int
}

struct Recipe: Identifiable, Decodable {
  let id: Int
  let name: String
  let ingredients: [String]
  let instructions: [String]
  let prepTimeMinutes: Int
  let cookTimeMinutes: Int
  let servings: Int
  let difficulty: String
  let cuisine: String
  let caloriesPerServing: Int
  let tags: [String]
  let userId: Int
  let image: String
  var imageURL: URL? { URL(string: image) }
  let rating: Double
  let reviewCount: Int
  let mealType: [String]
}

let payload = """
 {
   "recipes": [
     {
       "id": 1,
       "name": "Classic Margherita Pizza",
       "ingredients": [
         "Pizza dough",
         "Tomato sauce",
         "Fresh mozzarella cheese",
         "Fresh basil leaves",
         "Olive oil",
         "Salt and pepper to taste"
       ],
       "instructions": [
         "Preheat the oven to 475°F (245°C).",
         "Roll out the pizza dough and spread tomato sauce evenly.",
         "Top with slices of fresh mozzarella and fresh basil leaves.",
         "Drizzle with olive oil and season with salt and pepper.",
         "Bake in the preheated oven for 12-15 minutes or until the crust is golden brown.",
         "Slice and serve hot."
       ],
       "prepTimeMinutes": 20,
       "cookTimeMinutes": 15,
       "servings": 4,
       "difficulty": "Easy",
       "cuisine": "Italian",
       "caloriesPerServing": 300,
       "tags": [
         "Pizza",
         "Italian"
       ],
       "userId": 45,
       "image": "https://cdn.dummyjson.com/recipe-images/1.webp",
       "rating": 4.6,
       "reviewCount": 3,
       "mealType": [
         "Dinner"
       ]
     },
     {...},
     {...},
     {...}
     // 30 items
   ],

   "total": 100,
   "skip": 0,
   "limit": 30
 }
"""
