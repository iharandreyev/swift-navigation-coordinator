//
//  NavigationQueue.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import Foundation

@MainActor
final class NavigationQueue {
  // Fifo queue
  private var queue: [NavigationQueueItem] = []
  
  private init() { }
  
  static let shared = NavigationQueue()
  
  private var isResolvingQueue = false
  
  // Had to use completion handler due to a bug in Swift compiler: https://github.com/swiftlang/swift/issues/74382
  func scheduleUiUpdate(
    _ update: @escaping @MainActor () -> Void,
    completion: @escaping @MainActor (Bool) -> Void
  ) {
    let item = NavigationQueueItem(job: update, completion: completion)
    queue.append(item)
    
    guard !isResolvingQueue else { return }
    resolveQueue()
  }
  
  private func resolveQueue() {
    guard !queue.isEmpty else {
      isResolvingQueue = false
      return
    }
    
    isResolvingQueue = true
    
    let next = queue.removeFirst()
    next.job()

    DispatchQueue.main.asyncAfter(deadline: .now() + Duration.defaultAnimation().milliseconds / 1000) { [unowned self] in
      next.completion(true)
      resolveQueue()
    }
  }
}

private struct NavigationQueueItem {
  let job: () -> Void
  let completion: (Bool) -> Void
}

extension Duration {
    var milliseconds: Double {
        let v = components
        return Double(v.seconds) * 1000 + Double(v.attoseconds) * 1e-15
    }
}
