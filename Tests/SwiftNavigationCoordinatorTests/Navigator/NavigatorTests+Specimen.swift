//
//  NavigatorTests+Specimen.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import Testing

import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

extension NavigatorTests {
  @Test
  func replaceSpecimenDestination_finishes() async throws {
    try await withTimeout(Constants.timeout) {
      let sut = await createSut(specimenDestination: .first)
      let expectedDestination = TestDestination.second
      
      await sut.replaceSpecimenDestination(with: expectedDestination)
      
      let receivedDestination = await sut.specimenDestination()
      
      #expect(receivedDestination == expectedDestination)
    }
  }
}
