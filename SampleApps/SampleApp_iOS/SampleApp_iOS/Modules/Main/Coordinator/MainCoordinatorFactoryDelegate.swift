//
//  MainCoordinatorFactoryDelegate.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI
import SwiftNavigationCoordinator

// sourcery: AutoMockable
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
