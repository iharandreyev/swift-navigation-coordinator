//
//  AppCoordinatorFactoryDelegate.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

protocol AppCoordinatorFactoryDelegateType: CoordinatorFactoryDelegateType {
  associatedtype AppInitScreenType: View
  associatedtype OnboardingCoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType
  associatedtype MainCoordinatorType: StaticSpecimenCoordinatorType & LabelledSpecimenCoordinatorType
  
  func createAppInitScreen(
    onFinish: @escaping () -> Void
  ) -> AppInitScreenType
  
  func createOnboardingCoordinator(
    onFinish: @escaping () -> Void
  ) -> OnboardingCoordinatorType
  
  func createMainCoordinator() -> MainCoordinatorType
}

struct AppCoordinatorFactoryDelegate: AppCoordinatorFactoryDelegateType {
  func createAppInitScreen(
    onFinish: @escaping () -> Void
  ) -> some View {
    AppInitScreen(onFinish: onFinish)
  }
  
  func createOnboardingCoordinator(
    onFinish: @escaping () -> Void
  ) -> some ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType {
    OnboardingCoordinator(
      stackNavigator: StackNavigator(),
      modalNavigator: ModalNavigator(),
      factory: OnboardingCoordinatorFactoryDelegate(),
      onFinish: onFinish
    )
  }
  
  func createMainCoordinator() -> some StaticSpecimenCoordinatorType & LabelledSpecimenCoordinatorType {
    MainCoordinator(
      specimenNavigator: SpecimenNavigator(initialDestination: .usecases),
      factory: MainCoordinatorFactoryDelegate()
    )
  }
}
