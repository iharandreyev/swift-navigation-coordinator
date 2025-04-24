//
//  AnyNavigationQueue.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@MainActor
struct AnyNavigationQueue: NavigationQueueType, Sendable {
  private typealias ScheduleClosure = @Sendable (
    _ sourceFile: StaticString,
    _ line: UInt,
    _ function: StaticString,
    _ animated: Bool,
    _ update: @MainActor @Sendable @escaping () -> Void
  ) async -> Void
  
  private let _schedule: ScheduleClosure
  
  @_disfavoredOverload
  init<NavigationQueue: NavigationQueueType>(_ navigationQueue: NavigationQueue) {
    _schedule = { sourceFile, line, function, animated, update in
      await navigationQueue.schedule(
        sourceFile: sourceFile,
        line: line,
        function: function,
        animated: animated,
        update: update
      )
    }
  }

  init(_ navigationQueue: AnyNavigationQueue) {
    _schedule = navigationQueue._schedule
  }

  @inline(__always)
  func schedule(
    sourceFile: StaticString,
    line: UInt,
    function: StaticString,
    animated: Bool,
    update: @MainActor @Sendable @escaping () -> Void
  ) async {
    await _schedule(sourceFile, line, function, animated, update)
  }
}
