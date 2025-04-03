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
    onNext: Callback<Void>,
    onShowInfo: Callback<Void>
  ) -> StepScreenType
  
  func createInfoCoordinator(
    onFinish: Callback<Void>
  ) -> InfoCoordinatorType
}

struct OnboardingCoordinatorFactoryDelegate: OnboardingCoordinatorFactoryDelegateType {
  func createStepScreen(
    for step: OnboardingStep,
    onNext: Callback<Void>,
    onShowInfo: Callback<Void>
  ) -> some View {
    OnboardingStepScreen(
      step: step,
      onNext: onNext.callAsFunction,
      onShowInfo: onShowInfo.callAsFunction
    )
  }
  
  func createInfoCoordinator(
    onFinish: Callback<Void>
  ) -> some ScreenCoordinatorType & StackCoordinatorType {
    InfoCoordinator(
      stackNavigator: StackNavigator(),
      factory: InfoCoordinatorFactoryDelegate(),
      onFinish: onFinish
    )
  }
}
