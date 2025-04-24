//
//  MainCoordinatorFactoryDelegate.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI
import SwiftNavigationCoordinator

// sourcery: AutoMockable
@MainActor
protocol MainCoordinatorFactoryDelegateType {
  associatedtype UsecasesCoordinatorType: StackCoordinatorType & ModalCoordinatorType
  associatedtype DeeplinksCoordinatorType: NavigationCoordinatorType
  
  func createUsecasesCoordinator() -> UsecasesCoordinatorType
  func createDeeplinksCoordinator() -> DeeplinksCoordinatorType
}

struct MainCoordinatorFactoryDelegate: MainCoordinatorFactoryDelegateType {
  func createUsecasesCoordinator() -> UsecasesCoordinator {
    UsecasesCoordinator()
  }
  
  func createDeeplinksCoordinator() -> some NavigationCoordinatorType {
    DeeplinksCoordinator()
  }
}
