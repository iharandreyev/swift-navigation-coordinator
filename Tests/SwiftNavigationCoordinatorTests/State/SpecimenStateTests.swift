//
//  SpecimenStateTests.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import Perception
import Testing

@testable
import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

struct SpecimenStateTests {
  @Test
  func presentDestination_setsCorrectCoverDestination() async {
    let sut = await createSut()
    let expectedDestination = TestDestination.last
    
    await sut.setDestination(expectedDestination)
    
    #expect(await sut.destination() == expectedDestination)
  }
  
  @MainActor
  @Test
  func bindingUpdatesDestinationCorrectly() async {
    let sut = await createSut()
    let binding = Perception.Bindable(sut).destination(for: TestDestination.self)
    
    let expectedDestination = TestDestination.last

    // Simulate SUI update
    binding.wrappedValue = expectedDestination

    #expect(sut._destination == expectedDestination)
  }
}

extension SpecimenStateTests {
  typealias Sut = SpecimenState
  
  func createSut(destination: TestDestination = .first) async -> Sut {
    await Sut(initialDestination: destination)
  }
}
