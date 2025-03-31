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
    onNext: @escaping () -> Void
  ) -> StepScreenType
  
  func createInfoCoordinator(
    onFinish: @escaping () -> Void
  ) -> InfoCoordinatorType
}

struct OnboardingCoordinatorFactoryDelegate: OnboardingCoordinatorFactoryDelegateType {
  func createStepScreen(
    for step: OnboardingStep,
    onNext: @escaping () -> Void
  ) -> some View {
    Text("TBD")
  }
  
  func createInfoCoordinator(
    onFinish: @escaping () -> Void
  ) -> some ScreenCoordinatorType & StackCoordinatorType {
    InfoCoordinator(
      stackNavigator: StackNavigator(),
      onFinish: onFinish
    )
  }
}

private final class InfoCoordinator: CoordinatorBase, ScreenCoordinatorType, StackCoordinatorType {
  struct DestinationType: ScreenDestinationType { }
  
  let stackNavigator: StackNavigator<DestinationType>
  
  init(
    stackNavigator: StackNavigator<DestinationType>,
    onFinish: @escaping () -> Void
  ) {
    self.stackNavigator = stackNavigator
    
    super.init(onFinish: onFinish)
  }
  
  func initialScreen() -> some View {
    Text("TBD")
  }
  
  func screen(for destination: DestinationType) -> some View {
    Text("TBD")
  }
}
