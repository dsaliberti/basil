import Sharing
import SharedModels

public extension SharedKey where Self == InMemoryKey<Set<Recipe.ID>>.Default {
  static var favoriteRecipeIds: Self {
    Self[.inMemory("favoriteRecipeIds"), default: []]
  }
}
