import SwiftUI

public struct RecipeFavoriteButton: View {
  
  let isFavorite: Bool
  let action: () -> Void
  
  public init(
    isFavorite: Bool,
    action: @escaping () -> Void
  ) {
    self.isFavorite = isFavorite
    self.action = action
  }
  
  public var body: some View {
    Button {
      action()
    } label: {
      HStack {
        Text("Favorite")
          
        if isFavorite {
          Image(systemName: "star.fill")
            .foregroundStyle(.yellow)
        } else {
          Image(systemName: "star")
        }
      }
    }
    .font(.title2)
    .buttonStyle(BorderedButtonStyle())
    .tint(.secondary)
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  RecipeFavoriteButton(isFavorite: true) { }
}
