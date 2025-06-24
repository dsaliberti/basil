// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Core",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "Core",
      targets: ["Core"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      exact: "1.19.1"
    ),
    .package(path: "../SharedModels")
  ],
  targets: [
    .target(
      name: "Core",
      dependencies: [
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        ),
        "SharedModels"
      ]
    )
  ]
)
