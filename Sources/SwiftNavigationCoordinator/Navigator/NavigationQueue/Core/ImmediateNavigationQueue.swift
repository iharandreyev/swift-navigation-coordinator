//
//  ImmediateNavigationQueue.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@MainActor
struct ImmediateNavigationQueue: NavigationQueueType {
  init() { }

  func schedule(
    sourceFile: StaticString,
    line: UInt,
    function: StaticString,
    animated: Bool,
    update: @MainActor @Sendable @escaping () -> Void
  ) async {
    update()
  }
}
