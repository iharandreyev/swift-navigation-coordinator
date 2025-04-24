//
//  NavigatorTests+Modal.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import Testing

import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

extension NavigatorTests {
  @Test
  func presentDestination_finishes() async throws {
    try await withTimeout(Constants.timeout) {
      let sut = await createSut()
      let destination = TestModalDestination.cover(.first)
      
      await sut.presentDestination(destination)
      
      #expect(await sut.modalDestination() == destination)
    }
  }
  
  @Test
  func dismissDestination_finishes() async throws {
    try await withTimeout(Constants.timeout) {
      let sut = await createSut(modalDestination: .sheet(.first))
      
      await sut.dismissDestination()
      
      #expect(await sut.modalDestination() == nil)
    }
  }
}
