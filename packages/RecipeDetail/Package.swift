// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RecipeDetail",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "RecipeDetail",
      targets: ["RecipeDetail"]
    ),
  ],
  dependencies: [
    .package(path: "../Core")
  ],
  targets: [
    .target(
      name: "RecipeDetail",
      dependencies: [
        "Core"
      ]
    )
  ]
)

