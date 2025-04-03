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
    onFinish: Callback<Void>
  ) -> AppInitScreenType
  
  func createOnboardingCoordinator(
    onFinish: Callback<Void>
  ) -> OnboardingCoordinatorType
  
  func createMainCoordinator() -> MainCoordinatorType
}

struct AppCoordinatorFactoryDelegate: AppCoordinatorFactoryDelegateType {
  func createAppInitScreen(
    onFinish: Callback<Void>
  ) -> some View {
    AppInitScreen(onFinish: onFinish.callAsFunction)
  }
  
  func createOnboardingCoordinator(
    onFinish: Callback<Void>
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
