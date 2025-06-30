import SwiftUI
import SharedModels
import ComposableArchitecture

public struct FilterOptionsView: View {
  
  @Bindable var store: StoreOf<FilterOptionsFeature>
  
  public init(store: StoreOf<FilterOptionsFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      List {
        Section(header: Text("Select Difficulty:")) {
          Picker(
            "Recipe list difficulty filter selection",
            selection: $store.selectedDifficulty.sending(\.didSelectDifficulty)
          ) {
            ForEach(Difficulty.allCases) {
              Text($0.rawValue)
            }
          }
          .pickerStyle(.segmented)
        }
        
        Section(header: Text("Select Rating:")) {
          Picker(
            "Recipe list rating filter selection",
            selection: $store.selectedRating.sending(\.didSelectRating)
          ) {
            ForEach(Rating.allCases) {
              Text($0.title)
            }
          }
          .pickerStyle(.segmented)
        }
      }
      .listStyle(.grouped)
      .navigationTitle("Filter Options")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          
          Button(role: .cancel) {
            store.send(.didTapCancel)
          } label: {
            Text("Cancel")
          }
        }
        
        ToolbarItem(placement: .confirmationAction) {
          Button {
            store.send(.didTapConfirm)
          } label: {
            Text("Confirm")
          }
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var isPresented: Bool = true
  Text("🤠")
    .sheet(
      isPresented: $isPresented
    ) {
      FilterOptionsView(
        store: StoreOf<FilterOptionsFeature>(
          initialState: FilterOptionsFeature.State(),
          reducer: { FilterOptionsFeature() }
        )
      )
      .presentationDetents([.medium])
    }
}
