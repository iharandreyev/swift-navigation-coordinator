//
//  AppCoordinatorFactoryDelegateMock.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/4/25.
//

import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

#warning("TODO: Move into stencil template")
enum AppCoordinatorFactoryDelegateMock {
  typealias Dummy = AppCoordinatorFactoryDelegateTypeMock<DummyView, DummyCoordinator, DummyCoordinator>
  typealias DummyOnboarding<
    MainCoordinatorType: StaticSpecimenCoordinatorType & LabelledSpecimenCoordinatorType
  > = AppCoordinatorFactoryDelegateTypeMock<DummyView, MainCoordinatorType, DummyCoordinator>
  typealias DummyMain<
    OnboardingCoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType
  > = AppCoordinatorFactoryDelegateTypeMock<DummyView, DummyCoordinator, OnboardingCoordinatorType>
  typealias Full<
    MainCoordinatorType: StaticSpecimenCoordinatorType & LabelledSpecimenCoordinatorType,
    OnboardingCoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType
  > = AppCoordinatorFactoryDelegateTypeMock<DummyView, MainCoordinatorType, OnboardingCoordinatorType>
  
  @MainActor
  static func create() -> Dummy {
    let factory = Dummy()
    factory.createAppInitScreenOnFinishCallbackVoidReturnValue = DummyView()
    factory.createOnboardingCoordinatorOnFinishCallbackVoidReturnValue = DummyCoordinator()
    factory.createMainCoordinatorReturnValue = DummyCoordinator()
    return factory
  }
  
  @MainActor
  static func create<
    MainCoordinatorType: StaticSpecimenCoordinatorType & LabelledSpecimenCoordinatorType
  >(
    mainCoordinator: MainCoordinatorType
  ) -> DummyOnboarding<MainCoordinatorType> {
    let factory = DummyOnboarding<MainCoordinatorType>()
    factory.createAppInitScreenOnFinishCallbackVoidReturnValue = DummyView()
    factory.createOnboardingCoordinatorOnFinishCallbackVoidReturnValue = DummyCoordinator()
    factory.createMainCoordinatorReturnValue = mainCoordinator
    return factory
  }
  
  @MainActor
  static func create<
    OnboardingCoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType
  >(
    onboardingCoordinator: OnboardingCoordinatorType
  ) -> DummyMain<OnboardingCoordinatorType> {
    let factory = DummyMain<OnboardingCoordinatorType>()
    factory.createAppInitScreenOnFinishCallbackVoidReturnValue = DummyView()
    factory.createOnboardingCoordinatorOnFinishCallbackVoidReturnValue = onboardingCoordinator
    factory.createMainCoordinatorReturnValue = DummyCoordinator()
    return factory
  }
  
  @MainActor
  static func create<
    MainCoordinatorType: StaticSpecimenCoordinatorType & LabelledSpecimenCoordinatorType,
    OnboardingCoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType
  >(
    mainCoordinator: MainCoordinatorType,
    onboardingCoordinator: OnboardingCoordinatorType
  ) -> Full<MainCoordinatorType, OnboardingCoordinatorType> {
    let factory = Full<MainCoordinatorType, OnboardingCoordinatorType>()
    factory.createAppInitScreenOnFinishCallbackVoidReturnValue = DummyView()
    factory.createOnboardingCoordinatorOnFinishCallbackVoidReturnValue = onboardingCoordinator
    factory.createMainCoordinatorReturnValue = mainCoordinator
    return factory
  }
}
