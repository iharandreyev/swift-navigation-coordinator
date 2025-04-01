//
//  AppCoordinatorFactoryDelegateMock.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting
import SwiftUI

@testable
import SampleApp_iOS

#warning("TODO: Implement macro for this")
@MainActor
final class AppCoordinatorFactoryDelegateMock<
  OnboardingCoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType,
  MainCoordinatorType: StaticSpecimenCoordinatorType & LabelledSpecimenCoordinatorType
>: AppCoordinatorFactoryDelegateType {
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
  
  private let injected_createOnboardingCoordinator: (Params_createOnboardingCoordinator) -> OnboardingCoordinatorType
  private(set) var createOnboardingCoordinator_invocations: [Params_createOnboardingCoordinator] = []
  var createOnboardingCoordinator_count: Int { createOnboardingCoordinator_invocations.count }
  private var createOnboardingCoordinator_onFinish: (() -> Void)!
  
  private let createOnboardingCoordinator_invoked: ((Params_createOnboardingCoordinator) -> Void)?
  
  func createOnboardingCoordinator(
    onFinish: @escaping () -> Void
  ) -> OnboardingCoordinatorType {
    let params = Params_createOnboardingCoordinator(
      onFinish: onFinish
    )
    
    createOnboardingCoordinator_onFinish = onFinish
    createOnboardingCoordinator_invocations.append(params)
    createOnboardingCoordinator_invoked?(params)
    
    return injected_createOnboardingCoordinator(params)
  }
  
  func simulate_createOnboardingCoordinator_onFinish() {
    createOnboardingCoordinator_onFinish()
  }
  
  struct Params_createMainCoordinator { }
  
  private let injected_createMainCoordinator: (Params_createMainCoordinator) -> MainCoordinatorType
  private(set) var createMainCoordinator_invocations: [Params_createMainCoordinator] = []
  var createMainCoordinator_count: Int { createMainCoordinator_invocations.count }
  private let createMainCoordinator_invoked: ((Params_createMainCoordinator) -> Void)?

  func createMainCoordinator() -> MainCoordinatorType {
    let params = Params_createMainCoordinator()
    
    createMainCoordinator_invocations.append(params)
    createMainCoordinator_invoked?(params)
    
    return injected_createMainCoordinator(params)
  }
  
  init(
    createAppInitScreen_invoked: ((Params_createAppInitScreen) -> Void)? = nil,
    createOnboardingCoordinator: @escaping (Params_createOnboardingCoordinator) -> OnboardingCoordinatorType,
    createOnboardingCoordinator_invoked: ((Params_createOnboardingCoordinator) -> Void)? = nil,
    createMainCoordinator: @escaping (Params_createMainCoordinator) -> MainCoordinatorType,
    createMainCoordinator_invoked: ((Params_createMainCoordinator) -> Void)? = nil
  ) {
    self.createAppInitScreen_invoked = createAppInitScreen_invoked
    self.injected_createOnboardingCoordinator = createOnboardingCoordinator
    self.createOnboardingCoordinator_invoked = createOnboardingCoordinator_invoked
    self.injected_createMainCoordinator = createMainCoordinator
    self.createMainCoordinator_invoked = createMainCoordinator_invoked
  }
}

extension AppCoordinatorFactoryDelegateMock {
  convenience init(
    createAppInitScreen_invoked: ((Params_createAppInitScreen) -> Void)? = nil,
    createOnboardingCoordinator_invoked: ((Params_createOnboardingCoordinator) -> Void)? = nil,
    createMainCoordinator_invoked: ((Params_createMainCoordinator) -> Void)? = nil
  ) where OnboardingCoordinatorType == DummyCoordinator, MainCoordinatorType == DummyCoordinator {
    self.init(
      createAppInitScreen_invoked: createAppInitScreen_invoked,
      createOnboardingCoordinator: { _ in DummyCoordinator() },
      createOnboardingCoordinator_invoked: createOnboardingCoordinator_invoked,
      createMainCoordinator: { _ in DummyCoordinator() },
      createMainCoordinator_invoked: createMainCoordinator_invoked
    )
  }
  
  convenience init(
    createAppInitScreen_invoked: ((Params_createAppInitScreen) -> Void)? = nil,
    createOnboardingCoordinator_invoked: ((Params_createOnboardingCoordinator) -> Void)? = nil,
    createMainCoordinator: @escaping (Params_createMainCoordinator) -> MainCoordinatorType,
    createMainCoordinator_invoked: ((Params_createMainCoordinator) -> Void)? = nil
  ) where OnboardingCoordinatorType == DummyCoordinator {
    self.init(
      createAppInitScreen_invoked: createAppInitScreen_invoked,
      createOnboardingCoordinator: { _ in DummyCoordinator() },
      createOnboardingCoordinator_invoked: createOnboardingCoordinator_invoked,
      createMainCoordinator: createMainCoordinator,
      createMainCoordinator_invoked: createMainCoordinator_invoked
    )
  }
}
