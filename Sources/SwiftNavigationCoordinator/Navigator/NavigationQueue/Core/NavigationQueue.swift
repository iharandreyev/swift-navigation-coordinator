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
public actor NavigationQueue {
  private let withoutAnimations: WithoutAnimations
  private let withAnimations: WithAnimations
  
  // Fifo queue
  private var queue: [NavigationQueueItem] = []
  
  init<ClockType: Clock<Duration>>(
    clock: ClockType
  ) {
    self.withoutAnimations = WithoutAnimations(clock: clock)
    self.withAnimations = WithAnimations(clock: clock)
  }

  public func schedule(
    uiUpdate job: @MainActor @Sendable @escaping () -> Void,
    animation: Animation? = .default
  ) async  {
    if queue.isEmpty {
      await enqueueFirst(job, animation: animation)
    } else {
      await enqueueNext(job, animation: animation)
    }
  }
  
  private func enqueueFirst(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animation: Animation?
  ) async {
    enqueue(
      job,
      animation: animation
    )
    
    await resolveQueue()
  }
  
  private func enqueueNext(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animation: Animation?
  ) async  {
    await withCheckedContinuation { continuation in
      enqueue(
        job,
        animation: animation,
        completion: {
          continuation.resume()
        }
      )
    }
  }
  
  private func enqueue(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animation: Animation?,
    completion: NavigationQueueItem.Completion? = nil
  )  {
    let item = NavigationQueueItem(
      job: job,
      animation: animation,
      completion: completion
    )
    queue.append(item)
    
    logMessage("NavigationQueue: Did enqueue \(item)")
  }
  
  private func resolveQueue() async  {
    guard !queue.isEmpty else { return }
    
    let next = queue.removeFirst()
    
    logMessage("NavigationQueue: Did dequeue \(next)")
    
    if let animation = next.animation {
      await withAnimations.run(next.job, animation: animation)
    } else {
      await withoutAnimations.run(next.job)
    }

    await next.completion?()
    
    logMessage("NavigationQueue: Did complete \(next)")
    await resolveQueue()
  }
}

extension NavigationQueue {
#if canImport(XCTest)
  public static let shared = test()
#else
  public static let shared = NavigationQueue(clock: ContinuousClock())
#endif
}

struct NavigationQueueItem {
  fileprivate typealias Completion = @MainActor @Sendable () -> Void
  
  private(set) fileprivate var job: @MainActor @Sendable () -> Void
  private(set) fileprivate var animation: Animation?
  private(set) fileprivate var completion: Completion?
}

#if canImport(XCTest)

extension NavigationQueue {
  var queueLength: Int { queue.count }
  
  static func test() -> NavigationQueue {
    NavigationQueue(clock: ImmediateClock())
  }
}

#endif
