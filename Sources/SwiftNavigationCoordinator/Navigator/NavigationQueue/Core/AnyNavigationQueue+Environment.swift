//
//  AnyNavigationQueue+Environment.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import Clocks

extension AnyNavigationQueue {
  static func `for`(_ environment: Environment) -> AnyNavigationQueue {
    switch environment {
    case .debug, .release:
      return NavigationQueue(clock: ContinuousClock()).eraseToAnyNavigationQueue()
    case .test:
      return ImmediateNavigationQueue().eraseToAnyNavigationQueue()
    }
  }
}
