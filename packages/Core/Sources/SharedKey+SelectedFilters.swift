import Sharing
import SharedModels

public extension SharedKey where Self == InMemoryKey<FilterOptions>.Default {
  static var selectedFilters: Self {
    Self[.inMemory("selectedFilters"), default: .init(difficulty: .all, rating: .all)]
  }
}
