public enum Rating: Double, Identifiable, CaseIterable, Sendable, Decodable {
  
  public init?(rawValue: Double) {
    
    switch rawValue {
    case 4..<5:
      self = .fourPlus
    case 3..<5:
      self = .threePlus
    case 2..<5:
      self = .twoPlus
    case 1..<5:
      self = .onePlus
    
    default:
      self = .five
    }
  }
  
  case all
  case onePlus
  case twoPlus
  case threePlus
  case fourPlus
  case five
  
  public var id: Self { self }
  
  public var title: String {
    switch self {
    case .all:
      return "All"
    case .onePlus:
      return "1+"
    case .twoPlus:
      return "2+"
    case .threePlus:
      return "3+"
      case .fourPlus:
      return "4+"
    case .five:
      return "5"
    }
  }
}
