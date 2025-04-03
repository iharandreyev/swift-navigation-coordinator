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
  private let clock: AnyClock<Duration>
  
  private let withoutAnimations: WithoutAnimations
  private let withAnimations: WithAnimations
  
  // Fifo queue
  private var queue: [NavigationQueueItem] = []
  
  init<ClockType: Clock<Duration>>(
    clock: ClockType
  ) {
    self.clock = AnyClock(clock)
    self.withoutAnimations = WithoutAnimations(clock: clock)
    self.withAnimations = WithAnimations()
  }

  public func schedule(
    uiUpdate job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool
  ) async  {
    if queue.isEmpty {
      await enqueueFirst(job, animated: animated)
    } else {
      await enqueueNext(job, animated: animated)
    }
  }
  
  private func enqueueFirst(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool
  ) async {
    enqueue(
      job,
      animated: animated
    )
    
    await resolveQueue()
  }
  
  private func enqueueNext(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool
  ) async  {
    await withCheckedContinuation { continuation in
      enqueue(
        job,
        animated: animated,
        completion: {
          continuation.resume()
        }
      )
    }
  }
  
  private func enqueue(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    completion: NavigationQueueItem.Completion? = nil
  )  {
    let item = NavigationQueueItem(
      job: job,
      animated: animated,
      completion: completion
    )
    queue.append(item)
    
    logMessage("NavigationQueue: Did enqueue \(item)")
  }
  
  private func resolveQueue() async  {
    guard !queue.isEmpty else { return }
    
    let next = queue.removeFirst()
    
    logMessage("NavigationQueue: Did dequeue \(next)")
    
    if next.animated {
      await withAnimations.run(next.job)
    } else {
      await withoutAnimations.run(next.job)
    }

    await next.completion?()
    
    logMessage("NavigationQueue: Did complete \(next)")
    await resolveQueue()
  }
}

extension NavigationQueue {
#if !canImport(XCTest)
  public static let shared = NavigationQueue(clock: ContinuousClock())
#endif
}

struct NavigationQueueItem {
  fileprivate typealias Completion = @MainActor @Sendable () -> Void
  
  private(set) fileprivate var job: @MainActor @Sendable () -> Void
  private(set) fileprivate var animated: Bool
  private(set) fileprivate var completion: Completion?
}

#if canImport(XCTest)

extension NavigationQueue {
  var queueLength: Int { queue.count }
}

#endif
