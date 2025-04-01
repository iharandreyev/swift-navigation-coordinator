//
//  DeeplinkTests.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting
import SwiftUI
import Testing

@testable
import SampleApp_iOS

@MainActor
struct DeeplinkTests {
  @Test
  func canHandleDeeplink_onlyWhen_AppCoordinator_is_main() async throws {
    let navigator = SpecimenNavigator(
      initialDestination: AppDestination.appInit
    )
    let sut = AppCoordinator(
      specimenNavigator: navigator,
      factory: AppCoordinatorFactoryDelegateMockMinimal()
    )
    
    sut.addChild(DummyCoordinator(canHandleDeeplinks: true), as: AppDestination.appInit)
    sut.addChild(DummyCoordinator(canHandleDeeplinks: true), as: AppDestination.onboarding)
    sut.addChild(DummyCoordinator(canHandleDeeplinks: true), as: AppDestination.main)
    
    Deeplink.allCases.forEach {
      navigator.replaceDestination(with: .appInit)
      #expect(sut.handleDeeplink($0) == false)
      navigator.replaceDestination(with: .onboarding)
      #expect(sut.handleDeeplink($0) == false)
      navigator.replaceDestination(with: .main)
      #expect(sut.handleDeeplink($0) == true)
    }
  }
}
