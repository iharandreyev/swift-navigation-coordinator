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
final class NavigationQueue {
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
    uiUpdate job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    function: StaticString = #function
  ) async  {
    if queue.isEmpty {
      await enqueueFirst(job, animated: animated, function: function)
    } else {
      await enqueueNext(job, animated: animated, function: function)
    }
  }
  
  private func enqueueFirst(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    function: StaticString
  ) async {
    enqueue(
      job,
      animated: animated,
      function: function
    )
    
    await resolveQueue()
  }
  
  private func enqueueNext(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    function: StaticString
  ) async  {
    await withCheckedContinuation { continuation in
      enqueue(
        job,
        animated: animated,
        completion: {
          continuation.resume()
        },
        function: function
      )
    }
  }
  
  private func enqueue(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    completion: NavigationQueueItem.Completion? = nil,
    function: StaticString
  )  {
    let item = NavigationQueueItem(
      job: job,
      animated: animated,
      completion: completion,
      function: function
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
    function: StaticString
  ) {
    self.job = job
    self.animated = animated
    self.completion = completion
    self.description = "\(function)"
  }
}

extension NavigationQueue: NavigationQueueType {
  func schedule(
    sourceFile: StaticString,
    line: UInt,
    function: StaticString,
    animated: Bool,
    update: @MainActor @Sendable @escaping () -> Void
  ) async {
    await schedule(uiUpdate: update, animated: animated, function: function)
  }
}
