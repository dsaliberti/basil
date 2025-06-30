public enum Difficulty: String, Identifiable, CaseIterable, Decodable, Sendable, Equatable {
  case all = "All"
  case easy = "Easy"
  case medium = "Medium"
  case hard = "Hard"
  
  public var id: Self { self }
}
