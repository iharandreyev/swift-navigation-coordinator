//
//  AppCoordinatorTests.swift
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
struct AppCoordinatorTests {
  let factory = AppCoordinatorFactoryDelegateMock()
  
  init() {
    SwiftNavigationCoordinator.setEnvironment(.test)
  }
  
  @Test
  func screen_for_appInit_invokes_createAppInitScreen() {
    let sut = createSut(navigator: createNavigator())
    
    _ = sut.screen(for: .appInit)
    
    #expect(factory.createAppInitScreen_count == 1)
    #expect(factory.createOnboardingCoordinator_count == 0)
    #expect(factory.createMainCoordinator_count == 0)
  }
  
  @Test
  func screen_for_onboarding_invokes_createOnboardingCoordinator() {
    let sut = createSut(navigator: createNavigator())
    
    _ = sut.screen(for: .onboarding)
    
    #expect(factory.createAppInitScreen_count == 0)
    #expect(factory.createOnboardingCoordinator_count == 1)
    #expect(factory.createMainCoordinator_count == 0)
  }
  
  @Test
  func screen_for_main_invokes_reateMainCoordinator() {
    let sut = createSut(navigator: createNavigator())
    
    _ = sut.screen(for: .main)
    
    #expect(factory.createAppInitScreen_count == 0)
    #expect(factory.createOnboardingCoordinator_count == 0)
    #expect(factory.createMainCoordinator_count == 1)
  }

  @Test
  func appInit_finish_resultsIn_onboarding() async throws {
    let navigator = createNavigator(initialDestination: .appInit)
    let sut = createSut(navigator: navigator)
    _ = sut.screen(for: .appInit)
    
    let callback = factory.createAppInitScreen_invocations.first!.onFinish
    callback()
    await callback.onCompleted()
    
    #expect(navigator.destination == AppDestination.onboarding)
  }
  
  @Test
  func onboarding_finish_resultsIn_main() async throws {
    let navigator = createNavigator(initialDestination: .onboarding)
    let sut = createSut(navigator: navigator)
    _ = sut.screen(for: .onboarding)
    
    await factory.simulate_createOnboardingCoordinator_onFinish()
    
    #expect(navigator.destination == AppDestination.main)
  }

  private func createNavigator(
    initialDestination: AppDestination = .appInit
  ) -> SpecimenNavigator<AppDestination> {
    SpecimenNavigator(initialDestination: initialDestination)
  }
  
  private func createSut(
    navigator: SpecimenNavigator<AppDestination> = SpecimenNavigator(initialDestination: .appInit)
  ) -> AppCoordinator<AppCoordinatorFactoryDelegateMockDummy> {
    AppCoordinator(specimenNavigator: navigator, factory: factory)
  }
}

