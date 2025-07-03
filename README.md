# Basil app ![Basil-logo](https://github.com/user-attachments/assets/7c68233b-d6f1-438e-91f8-d68159fa4028)

A fresh iOS app made with Swift, SwiftUI, TCA and 💚

Basil app fetches recipes from the DummyJson API and shows them in an intuitive UI.
The main app target only instantiates the `RecipeList` at the App level.
Everything is separated into modules.

## Modules
- `RecipeList`: contains the views and reducer of the `RecipeList` feature,as well as the view and reducer of the `FilterOptions`.
- `RecipeDetail`: contains the view and reducer of the individual recipe `RecipeDetail` feature.

## Roadmap
Some improvements which could be considered for the future of Basil app:
- dynamic filters: the filters options could be populated with the properties from the loaded list. E.g if only one recipe is loaded with its difficulty as 'hard', then the filter options for difficulty should only show the option 'hard'. That would require to chain the filter options as the above ones would also filter the below ones.

- tag cloud on `RecipeDetailView`: at the bottom of the RecipeDetailView there's a horizontal scrollview to display its tags. The ideal would be to display them as a tag cloud where it displays like 'masonry' (an old school web js library) where the tags appear as in a HStack but when the horizontal limit is reached, another 'row' is dynamically added, until all tags are displayed.

- add SnapshotTesting so that the Views can be recorded and any further change would be detected, as well as increases the test coverage.

## 3rd party Dependencies
- [TCA (The Composable Architecture)](https://github.com/pointfreeco/swift-composable-architecture): "... a library for building applications in a consistent and understandable way, with composition, testing, and ergonomics in mind."

- [Kingfisher](https://github.com/onevcat/Kingfisher): "... a powerful, pure-Swift library for downloading and caching images from the web"

## How to run the app
- Checkout the repo, tap 'Trust' on the security dialog.
- Open the `Basil.xcodeproj` and keep an eye on the dependencies finish to load/checkout (turning greyed out to white).
- Trust all Macros errors and warnings.
- Run (Cmd+R) 🚀
 
## Tests
It's been tested on simulators iPhone 16 Pro and iPhone SE (3rd generation) all with iOS 18.4.It supports Light and Dark Appearances out of the box.

On failure or empty results, there's a pull-to-refresh so that users can retry conveniently. 

There are Previews in every view. `RecipeDetailView` and `FilterOptionsView` are previewed as they're presented in the list. The `RecipeListView` has all static states as well as the main states transitions in the previews with names.
 
### Unit Tests
Mainly the `RecipeList` module has UnitTests. For the list itself and the filters options.
The tests cover every Action (inputs) which could be called in the reducer and its possible variations.

To run the Tests:
- Select the Scheme `RecipeList` or `RecipeDetail` and hit Cmd+U to run all, or on the Test Navigator (Cmd+6) run each test individually.

Enjoy 🍲🍴

author: Danilo Soares Aliberti

dsaliberti

