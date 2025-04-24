//
//  AppCoordinatorFactoryDelegate.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

// sourcery: AutoMockable
@MainActor
protocol AppCoordinatorFactoryDelegateType {
  associatedtype AppInitScreenType: View
  associatedtype OnboardingCoordinatorType: StackCoordinatorType & ModalCoordinatorType
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
  ) -> OnboardingCoordinator<OnboardingCoordinatorFactoryDelegate> {
    OnboardingCoordinator(
      navigator: Navigator(),
      factory: OnboardingCoordinatorFactoryDelegate(),
      onFinish: onFinish
    )
  }
  
  func createMainCoordinator() -> MainCoordinator<MainCoordinatorFactoryDelegate> {
    MainCoordinator(
      navigator: Navigator(initialSpecimenDestination: MainTab.usecases),
      factory: MainCoordinatorFactoryDelegate()
    )
  }
}
