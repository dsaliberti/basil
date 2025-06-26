// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RecipeList",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "RecipeList",
      targets: ["RecipeList"]
    ),
  ],
  dependencies: [
    .package(path: "../Core")
  ],
  targets: [
    .target(
      name: "RecipeList",
      dependencies: [
        "Core"
      ]
    )
  ]
)
