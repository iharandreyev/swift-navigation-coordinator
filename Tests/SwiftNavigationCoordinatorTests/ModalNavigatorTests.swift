//
//  ModalNavigatorTests.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/4/25.
//

import Testing

@testable
import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

struct ModalNavigatorTests {
  init() {
    #warning("TODO: Looks like bad design, since `Environment.current` is updated for everything")
    setEnvironment(.test)
  }
  
  @Test
  func modalNavigator_setDestination_finishes() async throws {
    try await withTimeout(.seconds(1)) {
      let sut = await ModalNavigator<DummyDestination>.test()
      let destination = ModalDestination.sheet(DummyDestination())
      
      await sut.presentDestination(destination)
      
      #expect(await sut.destination == destination)
    }
    
    try await withTimeout(.seconds(1)) {
      let sut = await ModalNavigator<DummyDestination>.test()
      let destination = ModalDestination.cover(DummyDestination())
      
      await sut.presentDestination(destination)
      
      #expect(await sut.destination == destination)
    }
  }
  
  @Test
  func modalNavigator_dismissDestination_finishes() async throws {
    try await withTimeout(.seconds(1)) {
      let sut = await ModalNavigator<DummyDestination>.test(destination: .cover(DummyDestination()))

      await sut.dismissDestination()
      
      #expect(await sut.destination == nil)
    }
  }
}
