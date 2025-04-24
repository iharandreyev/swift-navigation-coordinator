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
  
  func createSut<Tag>(
    specimenDestination: TestDestinationOf<Tag>
  ) async -> Sut {
    await Sut(
      initialSpecimenDestination: specimenDestination,
      navigationQueue: NavigationQueue.test
    )
  }
  
  func createSut<Tag>(
    modalDestination: ModalDestinationPath<TestDestinationOf<Tag>>
  ) async -> Sut {
    await Sut(
      initialModalDestination: modalDestination,
      navigationQueue: NavigationQueue.test
    )
  }
  
  func createSut<Tag>(
    stack: OrderedSet<TestDestinationOf<Tag>>
  ) async -> Sut {
    await Sut(
      initialStack: stack.erase(),
      navigationQueue: NavigationQueue.test
    )
  }
  
  func createSut<T1, T2>(
    modalDestination: ModalDestinationPath<TestDestinationOf<T1>>,
    stack: OrderedSet<TestDestinationOf<T2>>
  ) async -> Sut {
    await Sut(
      initialModalDestination: modalDestination,
      initialStack: stack.erase(),
      navigationQueue: NavigationQueue.test
    )
  }
  
  func createSut() async -> Sut {
    await Sut(navigationQueue: NavigationQueue.test)
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
    static let timeout = Duration.milliseconds(1500)
  }
}
