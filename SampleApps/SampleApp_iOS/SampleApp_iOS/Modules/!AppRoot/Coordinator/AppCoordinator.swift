//
//  AppCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum AppDestination: String, DestinationType {
  case appInit
  case onboarding
  case main
}

@MainActor
final class AppCoordinator<
  FactoryDelegateType: AppCoordinatorFactoryDelegateType
>: CoordinatorBase, CoordinatorType, SpecimenCoordinatorType {
  typealias Destination = AppDestination
  
  let factory: FactoryDelegateType
  
  init(
    navigator: Navigator,
    factory: FactoryDelegateType
  ) {
    self.factory = factory
    
    super.init(navigator: navigator, onFinish: nil)
  }

  func screenContent(for destination: Destination) -> some View {
    switch destination {
    case .appInit:
      factory.createAppInitScreen(
        onFinish: Callback { [unowned self] in
          await initDidFinish()
        }
      )
    case .onboarding:
      CoordinatedScreen.stackRoot(
        modalCoordinator: addChild(
          childFactory: {
            factory.createOnboardingCoordinator(
              onFinish: Callback { [unowned self] in
                await onboardingDidFinish()
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
  
  func screenTransition(for destination: Destination) -> AnyTransition {
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
  
  func initDidFinish() async {
    await navigator.replaceSpecimenDestination(with: Destination.onboarding)
  }

  func onboardingDidFinish() async {
    await navigator.replaceSpecimenDestination(with: Destination.main)
  }
  
  override func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    switch deeplink {
    case _ as Deeplink:
      guard navigator.specimenDestination() == AppDestination.main else {
        return .impossible
      }
      
      return .partial
      
    default:
      return .impossible
    }
  }
}
