//
//  AppCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum AppDestination: ScreenDestinationType {
  case appInit
  case onboarding
  case main
}

@MainActor
final class AppCoordinator<
  FactoryDelegateType: AppCoordinatorFactoryDelegateType
>: CoordinatorBase, CoordinatorType, SpecimenCoordinatorType {
  typealias DestinationType = AppDestination
  
  let specimenNavigator: SpecimenNavigator<AppDestination>
  let factory: FactoryDelegateType
  
  init(
    specimenNavigator: SpecimenNavigator<AppDestination>,
    factory: FactoryDelegateType
  ) {
    self.specimenNavigator = specimenNavigator
    self.factory = factory
    
    super.init(onFinish: nil)
  }

  func screenContent(for destination: DestinationType) -> some View {
    switch destination {
    case .appInit:
      factory.createAppInitScreen(
        onFinish: { [weak self] in
          self?.initDidFinish()
        }
      )
    case .onboarding:
      CoordinatedScreen.stackRoot(
        modalCoordinator: addChild(
          childFactory: {
            factory.createOnboardingCoordinator(
              onFinish: { [weak self] in
                self?.onboardingDidFinish()
              }
            )
          },
          as: destination
        )
      )
    case .main:
      CoordinatedScreen.tabbed(
        coordinator: addChild(
          childFactory: factory.createMainCoordinator,
          as: destination
        )
      )
    }
  }
  
  func screenTransition(for destination: DestinationType) -> AnyTransition {
    switch destination {
    case .appInit:
      return .asymmetric(
        insertion: .opacity,
        removal: .move(edge: .leading)
      )
    case .onboarding:
      return .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading)
      )
    case .main:
      return .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading)
      )
    }
  }
  
  private func initDidFinish() {
    specimenNavigator.replaceDestination(with: .onboarding)
  }

  private func onboardingDidFinish() {
    specimenNavigator.replaceDestination(with: .main)
  }
}
