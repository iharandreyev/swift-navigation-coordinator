//
//  TestModalDestination.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import SwiftNavigationCoordinator

typealias TestModalDestination = ModalDestination<TestDestination>

extension TestModalDestination {
  init() {
    self = .cover(.first)
  }
  
  static var cover: Self {
    .cover(.first)
  }
  
  static var sheet: Self {
    .sheet(.first)
  }
}
