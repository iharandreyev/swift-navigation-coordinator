//
//  ModalStateTests.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import Perception
import Testing

@testable
import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

struct ModalStateTests {
  @Test
  func presentDestination_setsCorrectCoverDestination() async {
    let sut = await createSut()
    let expectedDestination = TestModalDestination.cover(.first)
    
    await sut.setDestination(expectedDestination)
    
    #expect(await sut.destination() == expectedDestination)
  }
  
  @Test
  func presentDestination_setsCorrectSheetDestination() async {
    let sut = await createSut()
    let expectedDestination = TestModalDestination.sheet(.first)
    
    await sut.setDestination(expectedDestination)
    
    #expect(await sut.destination() == expectedDestination)
  }
  
  @Test
  func dismissDestination_resetsDestination() async {
    let sut = await createSut(destination: .sheet)

    await sut.dismissDestination()
    
    #expect(await sut._destination == nil)
  }
  
  @MainActor
  @Test
  func bindingUpdatesDestinationCorrectly() async {
    let sut = await createSut(destination: .cover)
    let binding = sut.testBinding(for: TestDestination.self)

    // Simulate SUI dismiss
    binding.wrappedValue = nil
    
    #expect(sut._destination == nil)
  }
}

extension ModalStateTests {
  typealias Sut = ModalState
  
  func createSut(destination: TestModalDestination) async -> Sut {
    await Sut(initialDestination: destination)
  }
  
  func createSut() async -> Sut {
    await Sut()
  }
}
