//
//  NavigationQueue.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import Foundation

actor NavigationQueue {
  // Fifo queue
  private var queue: [NavigationQueueItem] = []
  
  private init() { }
  
  static let shared = NavigationQueue()
  
  private var isResolvingQueue = false
  
  // Had to use completion handler due to a bug in Swift compiler: https://github.com/swiftlang/swift/issues/74382
  func scheduleUiUpdate(
    _ update: @escaping @MainActor () -> Void,
    file: StaticString = #file,
    line: UInt = #line
  ) async {
    let item = NavigationQueueItem(job: update, file: file, line: line)
    queue.append(item)
    
    logMessage("NavigationQueue: Did enqueue \(item)")
    
    guard !isResolvingQueue else { return }
    await resolveQueue()
  }
  
  // Assume that task can never be cancelled
  private func resolveQueue() async {
    guard !queue.isEmpty else {
      isResolvingQueue = false
      return
    }
    
    isResolvingQueue = true
    
    let next = queue.removeFirst()
    
    logMessage("NavigationQueue: Did dequeue \(next)")
    
    await next.job()
    
    try! await Task.sleep(for: .defaultAnimation() * 2)
    logMessage("NavigationQueue: Did complete \(next)")
    await resolveQueue()
  }
}

private struct NavigationQueueItem: CustomStringConvertible {
  let job: @MainActor () -> Void
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
