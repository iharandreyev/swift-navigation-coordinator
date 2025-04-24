//
//  NavigationQueue+Testing.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

#if canImport(XCTest)

extension NavigationQueue {
  func testQueueLength() -> Int {
    queue.count
  }
}

#endif
