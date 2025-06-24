import Foundation
import SharedModels
import ComposableArchitecture

extension RestAPIClient: DependencyKey {
  
  public static let baseUrl = URL(string: "https://dummyjson.com/recipes")!
  
  public static var liveValue: RestAPIClient {
    Self(
      fetchAllRecipes: {
        let request = URLRequest(url: baseUrl)
        
        do {
          let (data, _) = try await URLSession.shared.data(for: request)
          let decoder = JSONDecoder()
          let recipes = try decoder.decode(
            Recipes.self,
            from: data
          )
          
          return recipes.recipes
          
        } catch {
          print("~>", error.localizedDescription)
          throw error
        }
      }
    )
  }
}
