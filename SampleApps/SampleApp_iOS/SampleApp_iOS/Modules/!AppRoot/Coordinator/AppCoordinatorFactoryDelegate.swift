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

struct AppCoordinatorFactoryDelegate: AppCoordinatorFactoryDelegateType {
  func createAppInitScreen(
    onFinish: @escaping () -> Void
  ) -> some View {
    AppInitScreen(onFinish: onFinish)
  }
  
  func createOnboardingCoordinator(
    onFinish: @escaping () -> Void
  ) -> some ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType {
    OnboardingCoordinator(
      stackNavigator: StackNavigator(),
      modalNavigator: ModalNavigator(),
      onFinish: onFinish
    )
  }
  
  func createMainCoordinator() -> some StaticSpecimenCoordinatorType & LabelledSpecimenCoordinatorType {
    MainCoordinator(
      specimenNavigator: SpecimenNavigator(initialDestination: MainCoordinator.DestinationType())
    )
  }
}

private final class OnboardingCoordinator: CoordinatorBase, ScreenCoordinatorType, StackCoordinatorType, ModalCoordinatorType {
  struct DestinationType: ScreenDestinationType, ModalDestinationContentType {
    let id = "static-id"
  }
  
  let stackNavigator: StackNavigator<DestinationType>
  let modalNavigator: ModalNavigator<DestinationType>
  
  init(
    stackNavigator: StackNavigator<DestinationType>,
    modalNavigator: ModalNavigator<DestinationType>,
    onFinish: @escaping () -> Void
  ) {
    self.stackNavigator = stackNavigator
    self.modalNavigator = modalNavigator
    
    super.init(onFinish: onFinish)
  }

  func initialScreen() -> some View {
    Text("TBD")
  }
  
  func screen(for destination: DestinationType) -> some View {
    Text("TBD")
  }
}

private final class MainCoordinator: CoordinatorBase, StaticSpecimenCoordinatorType, LabelledSpecimenCoordinatorType {
  struct DestinationType: ScreenDestinationType, CaseIterable {
    let id = "static-id"
    
    static let allCases: [MainCoordinator.DestinationType] = [DestinationType()]
  }
  
  let specimenNavigator: SpecimenNavigator<DestinationType>
  
  init(
    specimenNavigator: SpecimenNavigator<DestinationType>
  ) {
    self.specimenNavigator = specimenNavigator
    
    super.init()
  }

  @ViewBuilder
  func screenContent(for destination: DestinationType) -> some View {
    Text("TBD")
  }
  
  @ViewBuilder
  func label(for tab: DestinationType) -> some View {
    Text("TBD")
  }
}
