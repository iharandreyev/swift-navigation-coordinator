// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "SUINavigationCoordinator",
  platforms: [
    .iOS(.v16),
//    .macOS(.v13),
//    .tvOS(.v13),
//    .watchOS(.v6)
  ],
  products: [
    .library(
      name: "SUINavigationCoordinator",
      targets: [
        "SUINavigationCoordinator"
      ]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "1.5.4"),
    .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.3.0"),
    .package(url: "https://github.com/pointfreeco/swift-perception", from: "1.3.4"),
    .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "1.1.0"),
    .package(url: "https://github.com/iharandreyev/swift-ui-on-remove-from-parent", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "SUINavigationCoordinator",
      dependencies: [
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "Perception", package: "swift-perception"),
        .product(name: "SwiftUINavigation", package: "swift-navigation"),
        .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
        .product(name: "SUIOnRemoveFromParent", package: "swift-ui-on-remove-from-parent"),
      ]
    ),
    .testTarget(
      name: "SUINavigationCoordinatorTests",
      dependencies: [
        "SUINavigationCoordinator"
      ]
    ),
  ],
  swiftLanguageModes: [.v5]
)

for target in package.targets {
  var swiftSettings = target.swiftSettings ?? []
  swiftSettings.append(
    contentsOf: [
      .enableExperimentalFeature("StrictConcurrency")
    ]
  )
  target.swiftSettings = swiftSettings
}
