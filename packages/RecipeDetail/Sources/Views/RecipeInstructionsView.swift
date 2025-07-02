import SwiftUI

public struct RecipeInstructionsView: View {
  
  let instructions: [String]
  
  public init(instructions: [String]) {
    self.instructions = instructions
  }
  
  public var body: some View {
    Section(header: Text("**Instructions:**")) {
      
      ForEach(
        Array(instructions.enumerated()),
        id: \.offset
      ) { index, instruction in
        Text("\(index + 1)) \(instruction)")
          .font(.body)
          .padding(.vertical, 4)
      }
    }
  }
}
