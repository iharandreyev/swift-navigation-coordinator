//
//  NavigatorTests+Stack.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import OrderedCollections
import Testing

import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

extension NavigatorTests {
  @Test
  func push_singleDestination_yieldsCorrectResult() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: [],
        yields: [TestDestination.first],
        on: { sut in
          await sut.push(TestDestination.first)
        }
      )
    }
  }
  
  @Test
  func push_multipleDestinations_yieldsCorrectResult() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: [],
        yields: [TestDestination.first, .second, .third, .last],
        on: { sut in
          await sut.push(TestDestination.first)
          await sut.push(TestDestination.second)
          await sut.push(TestDestination.third)
          await sut.push(TestDestination.last)
        }
      )
    }
  }
  
  @Test
  func replaceLast_yieldsCorrectResult() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: [TestDestination.first, .second, .third],
        yields: [.first, .second, .last],
        on: { sut in
          await sut.replaceLast(with: TestDestination.last)
        }
      )
    }
  }
  
  @Test
  func replaceLast_doesNothing_whenEmpty() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: OrderedSet<TestDestination>(),
        yields: [],
        on: { sut in
          await sut.replaceLast(with: TestDestination.last)
        }
      )
    }
  }
  
  @Test
  func replacePath_yieldsCorrectResult_whenNotEmpty() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: [TestDestination.first, .second, .third],
        yields: [.last],
        on: { sut in
          await sut.replacePath(with: TestDestination.last)
        }
      )
    }
  }
  
  @Test
  func replacePath_yieldsCorrectResult_whenEmpty() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: [],
        yields: [TestDestination.last],
        on: { sut in
          await sut.replacePath(with: TestDestination.last)
        }
      )
    }
  }
  
  @Test
  func pop_singleDestination_yieldsCorrectResult() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: [TestDestination.first, .second, .third],
        yields: [.first, .second],
        on: { sut in
          await sut.pop()
        }
      )
    }
  }
  
  @Test
  func pop_multipleDestinations_yieldsCorrectResult() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: [TestDestination.first, .second, .third, .last],
        yields: [TestDestination.first],
        on: { sut in
          await sut.pop()
          await sut.pop()
          await sut.pop()
        }
      )
    }
  }
  
  @Test
  func pop_doesNothing_whenEmpty() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: OrderedSet<TestDestination>(),
        yields: [],
        on: { sut in
          await sut.pop()
        }
      )
    }
  }
  
  @Test
  func popToDestination_yieldsCorrectResult() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: [TestDestination.first, .second, .third, .last],
        yields: [.first, .second],
        on: { sut in
          await sut.popToDestination(TestDestination.second)
        }
      )
    }
  }
  
  @Test
  func popToDestination_doesNothing_whenInvalidDestination() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: [TestDestination.first, .second],
        yields: [.first, .second],
        on: { sut in
          await sut.popToDestination(TestDestination.third)
        }
      )
    }
  }
  
  @Test
  func popToRoot_yieldsCorrectResult() async throws {
    try await withTimeout(Constants.timeout) {
      await assertSut(
        withInputs: [TestDestination.first, .second],
        yields: [],
        on: { sut in
          await sut.popToRoot()
        }
      )
    }
  }
  
  @Test
  func continue_yieldsSynchronisedChild() async {
    let parent = await createSut(
      modalDestination: .cover(.last),
      stack: [TestDestination.first, .second, .third]
    )
    let child = await Navigator.continue(parent)
    
    #expect(await parent.stack() == child.stack())
    #expect(await parent.modalDestination() == TestModalDestination.cover(.last))
    #expect(await child.modalDestination() == nil)
    
    await child.push(TestDestinationOf<Tags.T1>.first)
    
    #expect(await parent.stack() == child.stack())
  }
  
  @MainActor
  @Test
  func childNavigator_popToRoot_popsAllChildren() async throws {
    let parent = await createSut(
      stack: [TestDestination.first, .second, .third]
    )
    
    let child1 = Navigator.continue(parent)
    await child1.push(TestDestinationOf<Tags.T1>.first)
    await child1.push(TestDestinationOf<Tags.T1>.second)
    
    let child2 = Navigator.continue(child1)
    await child2.push(TestDestinationOf<Tags.T2>.first)
    
    let child3 = Navigator.continue(child2)
    await child3.push(TestDestinationOf<Tags.T3>.first)
    
    await child2.popToRoot()
    
    #expect(parent.stack() == [])
    #expect(child1.stack() == [])
    #expect(child2.stack() == [])
    #expect(child3.stack() == [])
  }
}
