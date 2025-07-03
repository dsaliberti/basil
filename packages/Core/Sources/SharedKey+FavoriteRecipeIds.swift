import Sharing
import SharedModels

public extension SharedKey where Self == FileStorageKey<Set<Recipe.ID>>.Default {
  static var favoriteRecipeIds: Self {
    Self[.fileStorage(.documentsDirectory.appending(component: "favoriteRecipeIds.json")), default: []]
  }
}
