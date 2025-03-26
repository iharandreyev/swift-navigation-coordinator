// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "swift-navigation-coordinator",
  platforms: [
    .iOS(.v16),
//    .macOS(.v13),
//    .tvOS(.v13),
//    .watchOS(.v6)
  ],
  products: [
    .library(
      name: "SwiftNavigationCoordinator",
      targets: [
        "SwiftNavigationCoordinator"
      ]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "1.5.4"),
    .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.3.0"),
    .package(url: "https://github.com/pointfreeco/swift-perception", from: "1.3.4"),
    .package(url: "https://github.com/iharandreyev/swift-ui-on-remove-from-parent", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "SwiftNavigationCoordinator",
      dependencies: [
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "Perception", package: "swift-perception"),
        .product(name: "SwiftUINavigation", package: "swift-navigation"),
        .product(name: "SUIOnRemoveFromParent", package: "swift-ui-on-remove-from-parent"),
      ]
    ),
    .testTarget(
      name: "SwiftNavigationCoordinatorTests",
      dependencies: [
        "SwiftNavigationCoordinator"
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
