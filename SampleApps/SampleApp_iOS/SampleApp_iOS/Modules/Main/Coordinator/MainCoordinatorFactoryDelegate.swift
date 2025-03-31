//
//  MainCoordinatorFactoryDelegate.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI
import SwiftNavigationCoordinator

protocol MainCoordinatorFactoryDelegateType: CoordinatorFactoryDelegateType {
  associatedtype UsecasesCoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType
  associatedtype DeeplinksCoordinatorType: ScreenCoordinatorType
  
  func createUsecasesCoordinator() -> UsecasesCoordinatorType
  func createDeeplinksCoordinator() -> DeeplinksCoordinatorType
}

struct MainCoordinatorFactoryDelegate: MainCoordinatorFactoryDelegateType {
  func createUsecasesCoordinator() -> some ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType {
    UsecasesCoordinator()
  }
  
  func createDeeplinksCoordinator() -> some ScreenCoordinatorType {
    DeeplinksCoordinator()
  }
}

private final class UsecasesCoordinator: CoordinatorBase, ScreenCoordinatorType, StackCoordinatorType, ModalCoordinatorType {
  struct DestinationType: ModalDestinationContentType {
    let id = "temp"
  }
  
  let stackNavigator: StackNavigator<DestinationType>
  let modalNavigator: ModalNavigator<DestinationType>
  
  init(
    stackNavigator: StackNavigator<DestinationType> = StackNavigator(),
    modalNavigator: ModalNavigator<DestinationType> = ModalNavigator()
  ) {
    self.stackNavigator = stackNavigator
    self.modalNavigator = modalNavigator
  }
  
  func initialScreen() -> some View {
    Text("Usecases initial")
  }
  
  func screen(for destination: DestinationType) -> some View {
    Text("TBD")
  }
}

private final class DeeplinksCoordinator: CoordinatorBase, ScreenCoordinatorType {
  func initialScreen() -> some View {
    Text("Deeplinks initial")
  }
}
