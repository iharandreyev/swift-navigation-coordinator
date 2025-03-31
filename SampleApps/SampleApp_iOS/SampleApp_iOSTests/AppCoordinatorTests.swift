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
    
    factory.simulate_createAppInitScreen_onFinish()
    
    #expect(navigator.destination == AppDestination.onboarding)
  }
  
  @Test
  func onboarding_finish_resultsIn_main() async throws {
    let navigator = createNavigator(initialDestination: .onboarding)
    let sut = createSut(navigator: navigator)
    _ = sut.screen(for: .onboarding)
    
    factory.simulate_createOnboardingCoordinator_onFinish()
    
    #expect(navigator.destination == AppDestination.main)
  }
  
  @Test
  func canHandleDeeplink_onlyWhen_main() async throws {
    let navigator = createNavigator()
    let sut = createSut(navigator: navigator)
    
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

#warning("TODO: Implement macro for this")
@MainActor
final class AppCoordinatorFactoryDelegateMock: AppCoordinatorFactoryDelegateType {
  struct Params_createAppInitScreen {
    let onFinish: () -> Void
  }
  
  private(set) var createAppInitScreen_invocations: [Params_createAppInitScreen] = []
  var createAppInitScreen_count: Int { createAppInitScreen_invocations.count }
  private let createAppInitScreen_invoked: ((Params_createAppInitScreen) -> Void)?
  private var createAppInitScreen_onFinish: (() -> Void)!
  
  func createAppInitScreen(
    onFinish: @escaping () -> Void
  ) -> DummyView {
    let params = Params_createAppInitScreen(
      onFinish: onFinish
    )
    
    createAppInitScreen_onFinish = onFinish
    createAppInitScreen_invocations.append(params)
    createAppInitScreen_invoked?(params)
    
    return DummyView()
  }
  
  func simulate_createAppInitScreen_onFinish() {
    createAppInitScreen_onFinish()
  }
  
  struct Params_createOnboardingCoordinator {
    let onFinish: () -> Void
  }
  
  private(set) var createOnboardingCoordinator_invocations: [Params_createOnboardingCoordinator] = []
  var createOnboardingCoordinator_count: Int { createOnboardingCoordinator_invocations.count }
  private var createOnboardingCoordinator_onFinish: (() -> Void)!
  
  private let createOnboardingCoordinator_invoked: ((Params_createOnboardingCoordinator) -> Void)?
  
  func createOnboardingCoordinator(
    onFinish: @escaping () -> Void
  ) -> DummyCoordinator {
    let params = Params_createOnboardingCoordinator(
      onFinish: onFinish
    )
    
    createOnboardingCoordinator_onFinish = onFinish
    createOnboardingCoordinator_invocations.append(params)
    createOnboardingCoordinator_invoked?(params)
    
    return DummyCoordinator()
  }
  
  func simulate_createOnboardingCoordinator_onFinish() {
    createOnboardingCoordinator_onFinish()
  }
  
  struct Params_createMainCoordinator { }
  
  private(set) var createMainCoordinator_invocations: [Params_createMainCoordinator] = []
  var createMainCoordinator_count: Int { createMainCoordinator_invocations.count }
  private let createMainCoordinator_invoked: ((Params_createMainCoordinator) -> Void)?

  func createMainCoordinator() -> DummyCoordinator {
    let params = Params_createMainCoordinator()
    
    createMainCoordinator_invocations.append(params)
    createMainCoordinator_invoked?(params)
    
    return DummyCoordinator()
  }
  
  init(
    createAppInitScreen_invoked: ((Params_createAppInitScreen) -> Void)? = nil,
    createOnboardingCoordinator_invoked: ((Params_createOnboardingCoordinator) -> Void)? = nil,
    createMainCoordinator_invoked: ((Params_createMainCoordinator) -> Void)? = nil
  ) {
    self.createAppInitScreen_invoked = createAppInitScreen_invoked
    self.createOnboardingCoordinator_invoked = createOnboardingCoordinator_invoked
    self.createMainCoordinator_invoked = createMainCoordinator_invoked
  }
}
