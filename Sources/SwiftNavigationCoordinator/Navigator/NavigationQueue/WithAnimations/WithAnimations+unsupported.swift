//
//  WithAnimations+unsupported.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

#if !os(iOS)

actor WithAnimations_unsupported {
  func run(
    _ job: @MainActor @Sendable @escaping () -> Void
  ) async {
    fatalError("Current platform is not yet supported!")
  }
}

#endif
