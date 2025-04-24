//
//  AnyNavigationQueue.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@MainActor
struct AnyNavigationQueue: NavigationQueueType, Sendable {
  private typealias ScheduleClosure = @Sendable (
    _ update: @MainActor @Sendable @escaping () -> Void,
    _ animated: Bool,
    _ function: StaticString,
    _ file: StaticString,
    _ line: UInt
  ) async -> Void
  
  private let _schedule: ScheduleClosure
  
  @_disfavoredOverload
  init<NavigationQueue: NavigationQueueType>(_ navigationQueue: NavigationQueue) {
    _schedule = { update, animated, function, file, line in
      await navigationQueue.schedule(
        update: update,
        animated: animated,
        invokedIn: function,
        from: file,
        at: line
      )
    }
  }

  init(_ navigationQueue: AnyNavigationQueue) {
    _schedule = navigationQueue._schedule
  }

  @inline(__always)
  func schedule(
    update: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    invokedIn function: StaticString,
    from file: StaticString,
    at line: UInt
  ) async {
    await _schedule(update, animated, function, file, line)
  }
}
