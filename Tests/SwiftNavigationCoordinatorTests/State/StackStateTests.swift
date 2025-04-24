//
//  StackStateTests.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import OrderedCollections
import Perception
import Testing

@testable
import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

struct StackStateTests {
  @MainActor
  @Test
  func count_returnsCorrectValue() async {
    let sut = await createSut(stack: [.first, .second])
    
    #expect(sut.count == sut._path.count)
  }
  
  @Test
  func isEmpty_returnsCorrectValue() async {
    let filledSut = await createSut(stack: [.first, .second])
    let emptySut = await createSut()
    
    #expect(await filledSut.isEmpty == false)
    #expect(await emptySut.isEmpty == true)
  }
  
  @Test
  func append_updatesStateCorrectly() async {
    let sut = await createSut()
    let destination = TestDestination.first
    let expectedState = [destination]
    
    await sut.append(destination)
    
    #expect(await sut.stack() == expectedState)
    await assertSutIsInSync(sut)
  }
  
  @Test
  func removeLast_updatesStateCorrectly() async {
    let sut = await createSut(stack: [.first, .second])
    let expectedState = [TestDestination.first]
    
    await sut.removeLast()
    
    #expect(await sut.stack() == expectedState)
    await assertSutIsInSync(sut)
  }
  
  @Test
  func removeLastK_updatesStateCorrectly() async {
    let sut = await createSut(stack: [.first, .second, .third, .fourth])
    let expectedState = [TestDestination.first, .second]
    
    await sut.removeLast(2)
    
    #expect(await sut.stack() == expectedState)
    await assertSutIsInSync(sut)
  }
  
  @Test
  func index_returnsCorrectValue() async {
    let sut = await createSut(stack: [.first, .second, .third, .fourth])
    
    #expect(await sut.index(of: TestDestination.first) == 0)
    #expect(await sut.index(of: TestDestination.second) == 1)
    #expect(await sut.index(of: TestDestination.third) == 2)
    #expect(await sut.index(of: TestDestination.fourth) == 3)
    #expect(await sut.index(of: TestDestination.fifth) == nil)
  }
  
  @Test
  func removeAll_emptiesStack() async {
    let sut = await createSut(stack: [.first, .second, .third, .fourth])
    
    await sut.removeAll()
    
    #expect(await sut.stack() == [])
    await assertSutIsInSync(sut)
  }
  
  @MainActor
  @Test
  func bindingUpdatesDestinationCorrectly() async {
    let sut = await createSut(stack: [.first, .second, .third, .fourth])
    let binding = sut.testBinding()
    
    let expectedState = [TestDestination.first, .second, .third]
    
    // Simulate SUI update
    binding.wrappedValue.removeLast()

    #expect(sut.stack() == expectedState)
    
    await assertSutIsInSync(sut)
  }
}

extension StackStateTests {
  typealias Sut = StackState
  
  func createSut(stack: OrderedSet<TestDestination> = []) async -> Sut {
    let sut = await Sut()
    for id in stack {
      await sut.append(id)
    }
    return sut
  }
  
  @MainActor
  private func assertSutIsInSync(
    _ sut: Sut,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
  ) async {
    #expect(
      sut._stack.count == sut._path.count,
      "Expected stack and state to be of the same length, but they are not",
      sourceLocation: sourceLocation
    )
  }
}
