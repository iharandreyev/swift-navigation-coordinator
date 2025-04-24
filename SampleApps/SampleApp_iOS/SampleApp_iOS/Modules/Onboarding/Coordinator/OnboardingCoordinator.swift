//
//  OnboardingCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum OnboardingDestination: DestinationType, DestinationType {
  case step(OnboardingStep)
  case info
  
  var id: String {
    switch self {
    case let .step(step): return "step-\(step.id)"
    case .info: return "info"
    }
  }
}

@MainActor
final class OnboardingCoordinator<
  FactoryDelegateType: OnboardingCoordinatorFactoryDelegateType
>: CoordinatorBase, CoordinatorType, ScreenCoordinatorType, StackCoordinatorType, ModalCoordinatorType {
  typealias DestinationType = OnboardingDestination
  
  let navigator: StackNavigator<OnboardingDestination>
  let navigator: ModalNavigator<DestinationType>
  let factory: FactoryDelegateType
  
  private(set) var currentStepIdx = 0
  
  init(
    navigator: StackNavigator<DestinationType>,
    navigator: ModalNavigator<DestinationType>,
    factory: FactoryDelegateType,
    onFinish: Callback<Void>
  ) {
    self.navigator = navigator
    self.navigator = navigator
    self.factory = factory
    
    super.init(onFinish: onFinish)
  }
  
  func destinationDidDismiss(_ destination: OnboardingDestination) {
    logMessage("OnboardingCoordinator: Did dismiss \(destination)")
    revertToPreviousStep()
  }
  
  private func revertToPreviousStep() {
    guard currentStepIdx > 0 else { return }
    currentStepIdx -= 1
  }
  
  func initialScreen() -> some View {
    factory.createStepScreen(
      for: OnboardingStep.allCases[0],
      onNext: Callback { [unowned self] in
        await showNextStep()
      },
      onShowInfo: Callback{ [unowned self] in
        await showInfo()
      }
    )
    .onRemoveFromHierarchy(finish: self)
  }
  
  func screen(for destination: OnboardingDestination) -> some View {
    switch destination {
    case let .step(step):
      factory.createStepScreen(
        for: step,
        onNext: Callback{ [unowned self] in
          await showNextStep()
        },
        onShowInfo: Callback{ [unowned self] in
          await showInfo()
        }
      )
      .onRemoveFromParent { [weak self] in
        self?.destinationDidDismiss(destination)
      }
    case .info:
      CoordinatedScreen.stackRoot(
        stackCoordinator: addChild(
          childFactory: {
            factory.createInfoCoordinator(
              onFinish: Callback { [unowned self] in
                await infoDidFinish()
              }
            )
          },
          as: destination
        )
      )
    }
  }
  
  func showNextStep() async {
    guard let nextStep = nextStep() else {
      return await finish()
    }
    
    await navigator.push(.step(nextStep))
  }
  
  private func nextStep() -> OnboardingStep? {
    currentStepIdx += 1
    guard currentStepIdx < OnboardingStep.allCases.count else { return nil }
    return OnboardingStep.allCases[currentStepIdx]
  }
  
  func showInfo() async {
    await navigator.presentDestination(.sheet(.info))
  }
  
  func infoDidFinish() async {
    await navigator.dismissDestination()
  }
}
