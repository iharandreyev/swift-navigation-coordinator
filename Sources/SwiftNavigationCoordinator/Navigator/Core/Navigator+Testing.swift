//
//  Navigator+Testing.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

#if canImport(XCTest)

import Clocks
import SwiftUI

extension Navigator {
  static func test<Destination: SomeDestination>(
    specimenDestination: Destination? = nil,
    modalDestination: ModalDestinationPath<Destination>? = nil,
    stack: [Destination] = [],
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Navigator {
    let navigator = Navigator(navigationQueue: NavigationQueue(clock: ImmediateClock()))
    
    if let specimenDestination {
      navigator._specimenState.setDestination(specimenDestination)
    }
    
    if let modalDestination {
      navigator._modalState.setDestination(modalDestination)
    }
    
    stack.forEach {
      navigator._stackState.append($0, sourceFile: sourceFile, line: line)
    }
    
    return navigator
  }
  
  func testModalStateBinding<Destination: Sendable & Hashable & Identifiable>(
    for destinationType: Destination.Type = Destination.self
  ) -> Binding<ModalDestinationPath<Destination>?> {
    _modalState.testBinding(for: destinationType)
  }
  
  func testStackStateBinding() -> Binding<SwiftUI.NavigationPath> {
    _stackState.testBinding()
  }
}

#endif
