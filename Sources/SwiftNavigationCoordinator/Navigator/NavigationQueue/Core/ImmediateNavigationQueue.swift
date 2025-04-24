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
    update: @escaping NavigationQueueUpdate,
    animated: Bool,
    invokedIn function: StaticString,
    from file: StaticString,
    at line: UInt
  ) async {
    update()
  }
}
