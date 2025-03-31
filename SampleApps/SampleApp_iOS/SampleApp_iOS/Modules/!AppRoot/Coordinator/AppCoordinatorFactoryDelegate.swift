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
