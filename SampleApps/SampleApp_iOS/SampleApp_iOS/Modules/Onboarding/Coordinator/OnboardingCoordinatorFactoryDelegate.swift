//
//  OnboardingCoordinatorFactoryDelegate.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

protocol OnboardingCoordinatorFactoryDelegateType: CoordinatorFactoryDelegateType {
  associatedtype StepScreenType: View
  associatedtype InfoCoordinatorType: ScreenCoordinatorType & StackCoordinatorType
  
  func createStepScreen(
    for step: OnboardingStep,
    onNext: @escaping () -> Void,
    onShowInfo: @escaping () -> Void
  ) -> StepScreenType
  
  func createInfoCoordinator(
    onFinish: @escaping () -> Void
  ) -> InfoCoordinatorType
}

struct OnboardingCoordinatorFactoryDelegate: OnboardingCoordinatorFactoryDelegateType {
  func createStepScreen(
    for step: OnboardingStep,
    onNext: @escaping () -> Void,
    onShowInfo: @escaping () -> Void
  ) -> some View {
    OnboardingStepScreen(
      step: step,
      onNext: onNext,
      onShowInfo: onShowInfo
    )
  }
  
  func createInfoCoordinator(
    onFinish: @escaping () -> Void
  ) -> some ScreenCoordinatorType & StackCoordinatorType {
    InfoCoordinator(
      stackNavigator: StackNavigator(),
      factory: InfoCoordinatorFactoryDelegate(),
      onFinish: onFinish
    )
  }
}
