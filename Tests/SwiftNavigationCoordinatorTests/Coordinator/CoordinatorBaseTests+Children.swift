//
//  CoordinatorBaseTests+Children.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import Testing

@testable
import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

extension CoordinatorBaseTests {
  @Test
  func modalDismiss_finishesChildren() async throws {
    try await withTimeout(Constants.timeout) { @MainActor in
      let parent = CoordinatorBase(
        navigator: Navigator.test(),
        onFinish: Callback(job: {})
      )
      
      let child1Destination = TestDestination.first
      weak var child1 = parent.addChild(
        for: child1Destination
      ) {
        CoordinatorBase(
          navigator: Navigator.test(),
          onFinish: Callback(job: {})
        )
      }
      
      let child2Destination = TestDestinationOf<Tags.T1>.first
      weak var child2 = child1!.addChild(
        for: child2Destination
      ) { navigator in
        CoordinatorBase(
          navigator: navigator,
          onFinish: Callback(job: {})
        )
      }
      
      await parent.navigator.presentDestination(.cover(child1Destination))
      await child1?.navigator.push(child2Destination)
      
      let child1OnFinish = child1!.testOnFinish()!
      
      let binding = parent.navigator.testModalStateBinding(for: TestDestination.self)
      
      // Simulate SUI dismiss
      binding.wrappedValue = nil
      
      await child1OnFinish.onCompleted()
      
      #expect(child1 == nil)
      #expect(child2 == nil)
    }
  }
  
  @Test
  func pop_finishesChildren() async throws {
    try await withTimeout(Constants.timeout) { @MainActor in
      let parent = CoordinatorBase(
        navigator: Navigator.test(),
        onFinish: Callback(job: {})
      )
      
      let child1Destination = TestDestination.first
      weak var child1 = parent.addChild(
        for: child1Destination
      ) { navigator in
        CoordinatorBase(
          navigator: navigator,
          onFinish: Callback(job: {})
        )
      }
      
      let child2Destination = TestDestinationOf<Tags.T1>.first
      weak var child2 = child1!.addChild(
        for: child2Destination
      ) { navigator in
        CoordinatorBase(
          navigator: navigator,
          onFinish: Callback(job: {})
        )
      }
      
      await parent.navigator.push(child1Destination)
      await child1!.navigator.push(child2Destination)
      
      let child1OnFinish = child1!.testOnFinish()!
      
      let binding = parent.navigator.testStackStateBinding()
      
      // Simulate SUI pop
      binding.wrappedValue.removeLast()
      binding.wrappedValue.removeLast()
      
      await child1OnFinish.onCompleted()
      
      #expect(child1 == nil)
      #expect(child2 == nil)
    }
  }
}
