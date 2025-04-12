//
//  SpecimenNavigatorTests.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/4/25.
//

import Testing

@testable
import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

struct SpecimenNavigatorTests {
  init() {
    #warning("TODO: Looks like bad design, since `Environment.current` is updated for everything")
    setEnvironment(.test)
  }
  
  @Test
  func specimenNavigator_setDestination_finishes() async throws {
    try await withTimeout(.seconds(1)) {
      let sut = await SpecimenNavigator.test(destination: DummyDestination(id: "0"))

      await sut.replaceDestination(with: DummyDestination(id: "1"))
      
      #expect(await sut.destination.id == "1")
    }
  }
}
