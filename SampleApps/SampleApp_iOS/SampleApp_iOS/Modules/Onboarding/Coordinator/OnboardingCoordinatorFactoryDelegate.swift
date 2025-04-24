//
//  OnboardingCoordinatorFactoryDelegate.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

@MainActor
protocol OnboardingCoordinatorFactoryDelegateType {
  associatedtype StepScreenType: View
  associatedtype InfoCoordinatorType: StackCoordinatorType
  
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
  ) -> InfoCoordinator<InfoCoordinatorFactoryDelegate> {
    InfoCoordinator(
      navigator: Navigator(),
      factory: InfoCoordinatorFactoryDelegate(),
      onFinish: onFinish
    )
  }
}
