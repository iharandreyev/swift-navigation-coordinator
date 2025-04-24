//
//  OnboardingCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum OnboardingDestination {
  enum Modal: String, DestinationType {
    case info
  }
  
  enum Stack: DestinationType {
    case step(OnboardingStep)
    
    var id: String {
      switch self {
      case let .step(step): return "step-\(step.id)"
      }
    }
  }
}

@MainActor
final class OnboardingCoordinator<
  FactoryDelegateType: OnboardingCoordinatorFactoryDelegateType
>: CoordinatorBase, CoordinatorType, ScreenCoordinatorType, StackCoordinatorType, ModalCoordinatorType {
  let factory: FactoryDelegateType
  
  private(set) var currentStepIdx = 0
  
  // MARK: - Init
  
  init(
    navigator: Navigator,
    factory: FactoryDelegateType,
    onFinish: Callback<Void>
  ) {
    self.factory = factory
    
    super.init(navigator: navigator, onFinish: onFinish)
  }
  
  // MARK: - Navigation Coordinator

  typealias SpecimenDestination = DestinationNever
  typealias ModalDestination = OnboardingDestination.Modal
  typealias StackDestination = OnboardingDestination.Stack

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
  }
  
  @ViewBuilder
  func content(forSpecimen destination: SpecimenDestination) -> some View {
    EmptyView()
  }

  @ViewBuilder
  func content(forModal destination: ModalDestination) -> some View {
    switch destination {
    case .info:
      CoordinatedScreen.stackRoot(
        stackCoordinator: addChild(
          for: destination
        ) {
          factory.createInfoCoordinator(
            onFinish: Callback { [unowned self] in
              await infoDidFinish()
            }
          )
        }
      )
    }
  }

  @ViewBuilder
  func content(forStack destination: StackDestination) -> some View {
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
        self?.stepDidDismiss(step)
      }
    }
  }
  
  // MARK: Logic
  
  func stepDidDismiss(_ destination: OnboardingStep) {
    logMessage("OnboardingCoordinator: Did dismiss \(destination)")
    revertToPreviousStep()
  }
  
  private func revertToPreviousStep() {
    guard currentStepIdx > 0 else { return }
    currentStepIdx -= 1
  }
  
  func showNextStep() async {
    guard let nextStep = nextStep() else {
      return await finish()
    }
    
    await push(.step(nextStep))
  }
  
  private func nextStep() -> OnboardingStep? {
    currentStepIdx += 1
    guard currentStepIdx < OnboardingStep.allCases.count else { return nil }
    return OnboardingStep.allCases[currentStepIdx]
  }
  
  func showInfo() async {
    await presentDestination(.sheet(.info))
  }
  
  func infoDidFinish() async {
    await dismissDestination()
  }
}
