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
>: CoordinatorBase, SpecimenCoordinatorType {
  let factory: FactoryDelegateType
  
  // MARK: - Init
  
  init(
    navigator: Navigator,
    factory: FactoryDelegateType,
    onFinish: Callback<Void>? = nil
  ) {
    self.factory = factory
    
    super.init(navigator: navigator, onFinish: onFinish)
  }
  
  // MARK: - Navigation Coordinator
  
  typealias SpecimenDestination = AppDestination
  typealias ModalDestination = DestinationNever
  typealias StackDestination = DestinationNever

  func initialContent() -> some View {
    AppRoot(coordinator: self)
  }
  
  @ViewBuilder
  func content(forSpecimen destination: SpecimenDestination) -> some View {
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
          for: destination
        ) {
          factory.createOnboardingCoordinator(
            onFinish: Callback { [unowned self] in
              await onboardingDidFinish()
            }
          )
        }
      )
    case .main:
      addChild(
        for: destination,
        factory.createMainCoordinator
      )
      .initialContent()
    }
  }
  
  func transition(forSpecimen destination: SpecimenDestination) -> AnyTransition {
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
  
  @ViewBuilder
  func content(forModal destination: ModalDestination) -> some View {
    EmptyView()
  }

  @ViewBuilder
  func content(forStack destination: StackDestination) -> some View {
    EmptyView()
  }
  
  // MARK: - Logic
  
  func initDidFinish() async {
    await replaceSpecimenDestination(with: .onboarding)
  }

  func onboardingDidFinish() async {
    await replaceSpecimenDestination(with: .main)
  }
  
  // MARK: - Deeplink
  
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
