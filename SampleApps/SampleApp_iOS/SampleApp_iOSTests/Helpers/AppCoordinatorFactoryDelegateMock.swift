//
//  AppCoordinatorFactoryDelegateMock.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

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
