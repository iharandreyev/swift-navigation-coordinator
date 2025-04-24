//
//  NavigatorTests.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import OrderedCollections
import Testing

@testable
import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

struct NavigatorTests {
  typealias Sut = Navigator
  
  func createSut(
    specimenDestination: TestDestination
  ) async -> Sut {
    await Sut.test(
      specimenDestination: specimenDestination
    )
  }
  
  @_disfavoredOverload
  func createSut(
    modalDestination: TestModalDestination? = nil
  ) async -> Sut {
    await Sut.test(
      modalDestination: modalDestination
    )
  }
  
  func createSut<Tag>(
    modalDestination: ModalDestinationPath<TestDestinationOf<Tag>>? = nil,
    stack: OrderedSet<TestDestinationOf<Tag>>
  ) async -> Sut {
    await Sut.test(
      modalDestination: modalDestination,
      stack: stack.elements
    )
  }
  
  func assertSut<Tag>(
    withInputs inputs: OrderedSet<TestDestinationOf<Tag>>,
    yields result: OrderedSet<TestDestinationOf<Tag>>,
    on opearation: (Sut) async -> Void,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
  ) async {
    let sut = await createSut(stack: inputs)
    var stack = await sut.stack()
    
    #expect(
      stack == inputs.elements,
      "Expected stack to = `\(result)` before operation, but it is = `\(stack)`",
      sourceLocation: sourceLocation
    )
    
    await opearation(sut)
    
    stack = await sut.stack()
    
    #expect(
      stack == result.elements,
      "Expected stack to = `\(result)` after operation, but it is = `\(stack)`",
      sourceLocation: sourceLocation
    )
  }
  
  enum Constants {
    static let timeout = Duration.milliseconds(500)
  }
}
