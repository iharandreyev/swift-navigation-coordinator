//
//  NavigationQueue.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

import Clocks
import Foundation
import SwiftUI

/// Used to throttle animation completions to avoid multiple transitions at the same time
@MainActor
final class NavigationQueue: NavigationQueueType {
  private let withoutAnimations: WithoutAnimations
  private let withAnimations: WithAnimations
  
  // Fifo queue
  private(set) var queue: [NavigationQueueItem] = []
  
  nonisolated init<ClockType: Clock<Duration>>(
    clock: ClockType
  ) {
    self.withoutAnimations = WithoutAnimations(clock: clock)
    self.withAnimations = WithAnimations(clock: clock)
  }

  func schedule(
    update: @escaping NavigationQueueUpdate,
    animated: Bool,
    invokedIn function: StaticString,
    from file: StaticString,
    at line: UInt
  ) async {
    if queue.isEmpty {
      await enqueueFirst(
        update,
        animated: animated,
        invokedIn: function,
        from: file,
        at: line
      )
    } else {
      await enqueueNext(
        update,
        animated: animated,
        invokedIn: function,
        from: file,
        at: line
      )
    }
  }
  
  private func enqueueFirst(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    invokedIn function: StaticString,
    from file: StaticString,
    at line: UInt
  ) async {
    enqueue(
      job,
      animated: animated,
      invokedIn: function,
      from: file,
      at: line
    )
    
    await resolveQueue()
  }
  
  private func enqueueNext(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    invokedIn function: StaticString,
    from file: StaticString,
    at line: UInt
  ) async  {
    await withCheckedContinuation { continuation in
      enqueue(
        job,
        animated: animated,
        completion: {
          continuation.resume()
        },
        invokedIn: function,
        from: file,
        at: line
      )
    }
  }
  
  private func enqueue(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    completion: NavigationQueueItem.Completion? = nil,
    invokedIn function: StaticString,
    from file: StaticString,
    at line: UInt
  )  {
    let item = NavigationQueueItem(
      job: job,
      animated: animated,
      completion: completion,
      invokedIn: function,
      from: file,
      at: line
    )
    queue.append(item)
  }
  
  private func resolveQueue() async  {
    guard !queue.isEmpty else { return }
    
    let next = queue.removeFirst()
    
    if next.animated {
      await withAnimations.run(next.job)
    } else {
      await withoutAnimations.run(next.job)
    }

    next.completion?()
    
    logMessage("NavigationQueue: Did complete \(next)")
    
    await resolveQueue()
  }
}

extension NavigationQueue {
  static let live = NavigationQueue(clock: ContinuousClock())
  static let test = NavigationQueue(clock: ImmediateClock())
}

struct NavigationQueueItem: CustomStringConvertible {
  fileprivate typealias Completion = @MainActor @Sendable () -> Void
  
  fileprivate let job: @MainActor @Sendable () -> Void
  fileprivate let animated: Bool
  fileprivate let completion: Completion?

  let description: String

  fileprivate init(
    job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    completion: Completion? = nil,
    invokedIn function: StaticString,
    from file: StaticString,
    at line: UInt
  ) {
    self.job = job
    self.animated = animated
    self.completion = completion
    self.description = "`\(function)` called from `\(file):\(line)`"
  }
}
