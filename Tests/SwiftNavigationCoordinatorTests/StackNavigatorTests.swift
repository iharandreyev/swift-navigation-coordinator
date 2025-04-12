//
//  StackNavigatorTests.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/4/25.
//

import Testing
import Perception

@testable
import SwiftNavigationCoordinator

struct StackNavigatorTests {
  init() {
    #warning("TODO: Looks like bad design, since `Environment.current` is updated for everything")
    setEnvironment(.test)
  }
  
  @Test
  func stackNavigator_pushesSingleDestination() async throws {
    await assertSut(
      withInputs: [],
      yields: [TestDestination.first],
      on: { sut in
        await sut.push(.first)
      }
    )
  }
  
  @Test
  func stackNavigator_pushesMultipleDestinations() async throws {
    await assertSut(
      withInputs: [],
      yields: [TestDestination.first, .second, .third, .last],
      on: { sut in
        await sut.push(.first)
        await sut.push(.second)
        await sut.push(.third)
        await sut.push(.last)
      }
    )
  }
  
  #warning("TODO: Enable commented-out tests when underlying issues are fixed")
//  @Test
//  func stackNavigator_replacesLast() async throws {
//    await assertSut(
//      withInputs: [TestDestination.first, .second, .third],
//      yields: [.first, .second, .last],
//      on: { sut in
//        await sut.replaceLast(with: .last)
//      }
//    )
//  }
//  
//  @Test
//  func stackNavigator_replaceLast_doesNothingWhenEmpty() async throws {
//    await assertSut(
//      withInputs: [TestDestination](),
//      yields: [],
//      on: { sut in
//        await sut.replaceLast(with: .last)
//      }
//    )
//  }
//  
//  @Test
//  func stackNavigator_replacesStack() async throws {
//    await assertSut(
//      withInputs: [TestDestination.first, .second, .third],
//      yields: [.last],
//      on: { sut in
//        await sut.replaceStack(with: .last)
//      }
//    )
//  }
//  
//  @Test
//  func stackNavigator_replaceStack_setsStackWhenEmpty() async throws {
//    await assertSut(
//      withInputs: [TestDestination](),
//      yields: [.last],
//      on: { sut in
//        await sut.replaceStack(with: .last)
//      }
//    )
//  }
  
  @Test
  func stackNavigator_popsSingleDestination() async throws {
    await assertSut(
      withInputs: [TestDestination.first, .second, .third],
      yields: [.first, .second],
      on: { sut in
        await sut.pop()
      }
    )
  }
  
  @Test
  func stackNavigator_popsMultipleDestinations() async throws {
    await assertSut(
      withInputs: [TestDestination.first, .second, .third],
      yields: [],
      on: { sut in
        await sut.pop()
        await sut.pop()
        await sut.pop()
      }
    )
  }
  
  @Test
  func stackNavigator_pop_doesNothingWhenEmpty() async throws {
    await assertSut(
      withInputs: [TestDestination](),
      yields: [],
      on: { sut in
        await sut.pop()
      }
    )
  }
  
  @Test
  func stackNavigator_popsToDestination() async throws {
    await assertSut(
      withInputs: [TestDestination.first, .second, .third, .last],
      yields: [.first, .second],
      on: { sut in
        await sut.popToDestination(.second)
      }
    )
  }
  
  @Test
  func stackNavigator_popToDestination_doesNothingForInvalidDestination() async throws {
    await assertSut(
      withInputs: [TestDestination.first, .second],
      yields: [.first, .second],
      on: { sut in
        await sut.popToDestination(.third)
      }
    )
  }
  
  @Test
  func stackNavigator_popsToRoot() async throws {
    await assertSut(
      withInputs: [TestDestination.first, .second],
      yields: [],
      on: { sut in
        await sut.popToRoot()
      }
    )
  }
  
  @Test
  func stackNavigator_doesNothing_whenInvalid() async throws {
    #warning("TODO: Enable commented-out tests when underlying issues are fixed")
    let operations: [(Sut<TestDestination>) async -> Void] = [
      { await $0.push(.last) },
//      { await $0.replaceLast(with: .last) },
//      { await $0.replaceStack(with: .last) },
      { await $0.pop() },
      { await $0.popToDestination(.first) },
      { await $0.popToRoot() }
    ]
    
    for operation in operations {
      await assertSut(
        withInputs: [TestDestination.first, .second, .third],
        isValid: false,
        yields: [.first, .second, .third],
        on: { sut in
          await operation(sut)
        }
      )
    }
  }
  
  @Test
  func stackNavigator_scopes() async {
    let parent = await Sut<TestDestination>.test(destinations: [.first, .second, .third])
    let child: Sut<TestChildDestination> = await parent.scope()
    
    #expect(await child.isValid)
    #expect(await child.parent == parent)
    #expect(await parent.child == child)
  }
  
  @MainActor
  @Test
  func stackNavigator_scope_switchesStateDelegateProperly() async throws {
    let parent = Sut<TestDestination>.test(destinations: [.first, .second, .third])
    let pathBinding = Perception.Bindable(parent.state).path()
    
    let child: Sut<TestChildDestination> = parent.scope()
    
    // Simulate SUI pop
    pathBinding.wrappedValue.removeLast()
    
    #expect(parent.stack == [.first, .second])
    #expect(!child.isValid)
    #expect(await child.parent == nil)
    #expect(await parent.child == nil)
  }
  
  @MainActor
  @Test
  func stackNavigator_scoped_popsToRoot() async throws {
    let parent = Sut<TestDestination>.test(destinations: [.first, .second, .third])

    let child1: Sut<TestChildDestination> = parent.scope()
    await child1.push(.firstCh)
    await child1.push(.secondCh)
    
    let child2: Sut<TestDestination> = child1.scope()
    await child2.push(.first)
    
    let child3: Sut<TestDestination> = child2.scope()
    await child3.push(.second)
    
    #expect(parent.child == child1)
    #expect(child1.parent == parent)
    #expect(child1.child == child2)
    #expect(child2.parent == child1)
    #expect(child2.child == child3)
    #expect(child3.parent == child2)
    #expect(child3.child == nil)
    
    await child2.popToRoot()
    
    #expect(parent.child == nil)
    #expect(parent.stack == [])
    #expect(child1.parent == nil)
    #expect(child1.child == nil)
    #expect(child1.stack == [])
    #expect(child2.parent == nil)
    #expect(child2.child == nil)
    #expect(child2.stack == [])
    #expect(child3.parent == nil)
    #expect(child3.child == nil)
    #expect(child3.stack == [])
  }
  
  @MainActor
  @Test
  func stackNavigator_invalidate_updatesHierarchyProperly() async throws {
    let parent = Sut<TestDestination>.test(destinations: [])
    let child1: Sut<TestChildDestination> = parent.scope()
    let child2: Sut<TestChildDestination> = child1.scope()
    let child3: Sut<TestChildDestination> = child2.scope()
    
    child1.testInvalidate()
    
    #expect(parent.isValid)
    #expect(parent.child == nil)
    #expect(!child1.isValid)
    #expect(child1.parent == nil)
    #expect(child1.child == nil)
    #expect(!child2.isValid)
    #expect(child2.parent == nil)
    #expect(child2.child == nil)
    #expect(!child3.isValid)
    #expect(child3.parent == nil)
    #expect(child3.child == nil)
  }
}

private enum TestDestination: String, ScreenDestinationType, CustomStringConvertible {
  case first
  case second
  case third
  case last
  
  var description: String {
    "Destination.\(rawValue)"
  }
}

private enum TestChildDestination: String, ScreenDestinationType, CustomStringConvertible {
  case firstCh
  case secondCh
  case lastCh
  
  var description: String {
    "ChildDestination.\(rawValue)"
  }
}

typealias Sut = StackNavigator

private func assertSut<Destination>(
  withInputs inputs: [Destination],
  isValid: Bool = true,
  yields result: [Destination],
  on opearation: (Sut<Destination>) async -> Void,
  sourceLocation: Testing.SourceLocation = #_sourceLocation
) async {
  let sut = await Sut.test(destinations: inputs, isValid: isValid)
  var stack = await sut.stack
  
  #expect(
    stack == inputs,
    "Expected stack to = `\(result)` before operation, but it is = `\(stack)`",
    sourceLocation: sourceLocation
  )
  
  await assertSutIsInSync(sut, sourceLocation: sourceLocation)

  await opearation(sut)
  
  stack = await sut.stack
  
  #expect(
    stack == result,
    "Expected stack to = `\(result)` after operation, but it is = `\(stack)`",
    sourceLocation: sourceLocation
  )
  
  await assertSutIsInSync(sut, sourceLocation: sourceLocation)
}

private func assertSutIsInSync<Destination>(
  _ sut: Sut<Destination>,
  sourceLocation: Testing.SourceLocation = #_sourceLocation
) async {
  #expect(
    await sut.state.count == sut.stack.count,
    "Expected stack and state to be of the same length, but they are not",
    sourceLocation: sourceLocation
  )
}
