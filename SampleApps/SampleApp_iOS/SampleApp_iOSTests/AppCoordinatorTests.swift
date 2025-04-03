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
  typealias AppCoordinatorFactoryDelegateMock = AppCoordinatorFactoryDelegateTypeMock<DummyView, DummyCoordinator, DummyCoordinator>
  
  let factory: AppCoordinatorFactoryDelegateMock
  
  init() {
    factory = AppCoordinatorFactoryDelegateMock()
    factory.createAppInitScreenOnFinishCallbackVoidReturnValue = DummyView()
    factory.createOnboardingCoordinatorOnFinishCallbackVoidReturnValue = DummyCoordinator()
    factory.createMainCoordinatorReturnValue = DummyCoordinator()
  }
  
  init() {
    SwiftNavigationCoordinator.setEnvironment(.test)
  }
  
  @Test
  func screen_for_appInit_invokes_createAppInitScreen() {
    let sut = createSut(navigator: createNavigator())
    
    _ = sut.screen(for: .appInit)
    
    #expect(factory.createAppInitScreenOnFinishCallbackVoidCallsCount == 1)
    #expect(factory.createOnboardingCoordinatorOnFinishCallbackVoidCallsCount == 0)
    #expect(factory.createMainCoordinatorCallsCount == 0)
  }
  
  @Test
  func screen_for_onboarding_invokes_createOnboardingCoordinator() {
    let sut = createSut(navigator: createNavigator())
    
    _ = sut.screen(for: .onboarding)
    
    #expect(factory.createAppInitScreenOnFinishCallbackVoidCallsCount == 0)
    #expect(factory.createOnboardingCoordinatorOnFinishCallbackVoidCallsCount == 1)
    #expect(factory.createMainCoordinatorCallsCount == 0)
  }
  
  @Test
  func screen_for_main_invokes_reateMainCoordinator() {
    let sut = createSut(navigator: createNavigator())
    
    _ = sut.screen(for: .main)
    
    #expect(factory.createAppInitScreenOnFinishCallbackVoidCallsCount == 0)
    #expect(factory.createOnboardingCoordinatorOnFinishCallbackVoidCallsCount == 0)
    #expect(factory.createMainCoordinatorCallsCount == 1)
  }

  @Test
  func appInit_finish_resultsIn_onboarding() async throws {
    let navigator = createNavigator(initialDestination: .appInit)
    let sut = createSut(navigator: navigator)
    _ = sut.screen(for: .appInit)
    
    let finishAppInit = factory.createAppInitScreenOnFinishCallbackVoidReceivedInvocations.first!
    finishAppInit()
    await finishAppInit.onCompleted()
    
    #expect(navigator.destination == AppDestination.onboarding)
  }
  
  @Test
  func onboarding_finish_resultsIn_main() async throws {
    let navigator = createNavigator(initialDestination: .onboarding)
    let sut = createSut(navigator: navigator)
    _ = sut.screen(for: .onboarding)
    
    let finishOnboarding = factory.createOnboardingCoordinatorOnFinishCallbackVoidReceivedInvocations.first!
    finishOnboarding()
    await finishOnboarding.onCompleted()

    #expect(navigator.destination == AppDestination.main)
  }

  private func createNavigator(
    initialDestination: AppDestination = .appInit
  ) -> SpecimenNavigator<AppDestination> {
    SpecimenNavigator(initialDestination: initialDestination)
  }
  
  private func createSut(
    navigator: SpecimenNavigator<AppDestination> = SpecimenNavigator(initialDestination: .appInit)
  ) -> AppCoordinator<AppCoordinatorFactoryDelegateMock> {
    AppCoordinator(specimenNavigator: navigator, factory: factory)
  }
}

