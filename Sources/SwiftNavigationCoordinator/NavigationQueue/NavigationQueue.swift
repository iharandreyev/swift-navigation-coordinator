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
    completion: @escaping @MainActor (Bool) -> Void,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let item = NavigationQueueItem(job: update, completion: completion, file: file, line: line)
    queue.append(item)
    
    logMessage("NavigationQueue: Did enqueue \(item)")
    
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
    
    logMessage("NavigationQueue: Did dequeue \(next)")
    
    next.job()

    let delay = Duration.defaultAnimation().milliseconds / 1000 * 2
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
      next.completion(true)
      logMessage("NavigationQueue: Did complete \(next)")
      resolveQueue()
    }
  }
}

private struct NavigationQueueItem: CustomStringConvertible {
  let job: () -> Void
  let completion: (Bool) -> Void
  let file: StaticString
  let line: UInt
  
  var description: String {
    "Operation scheduled at \(file):\(line)"
  }
}

extension Duration {
    var milliseconds: Double {
        let v = components
        return Double(v.seconds) * 1000 + Double(v.attoseconds) * 1e-15
    }
}
