public struct FilterOptions: Sendable, Equatable {
  public var difficulty: Difficulty
  public var rating: Rating
  
  public init(
    difficulty: Difficulty = .all,
    rating: Rating = .all
  ) {
    self.difficulty = difficulty
    self.rating = rating
  }
}
