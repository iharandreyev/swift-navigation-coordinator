//
//  NavigationQueue+Envrionment.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import Clocks

extension NavigationQueue {
  static func `for`(_ environment: Environment) -> NavigationQueue {
    switch environment {
    case .debug, .release:
      return NavigationQueue(clock: ContinuousClock())
    case .test:
      return NavigationQueue(clock: ImmediateClock())
    }
  }
}
