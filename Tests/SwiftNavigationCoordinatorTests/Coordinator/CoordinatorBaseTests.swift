//
//  CoordinatorBaseTests.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import SwiftNavigationCoordinator

struct CoordinatorBaseTests {
  typealias Sut = CoordinatorBase
  
  init() {
    #warning("TODO: Looks like bad design, since `Environment.current` is updated for everything")
    setEnvironment(.test)
  }
  
  enum Constants {
    static let timeout = Duration.milliseconds(500)
  }
}
