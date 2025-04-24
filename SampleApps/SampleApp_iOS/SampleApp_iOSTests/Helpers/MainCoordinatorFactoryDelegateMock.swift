//
//  MainCoordinatorFactoryDelegateMock.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting

enum MainCoordinatorFactoryDelegateMock {
  typealias Dummy = MainCoordinatorFactoryDelegateTypeMock<
    DummyCoordinator,
    DummyCoordinator
  >
  
  typealias DummyDeeplinks<
    UsecasesCoordinatorType: NavigationCoordinatorType & StackCoordinatorType & ModalCoordinatorType
  > = MainCoordinatorFactoryDelegateTypeMock<
    DummyCoordinator,
    UsecasesCoordinatorType
  > where UsecasesCoordinatorType.ModalDestination: DestinationType, UsecasesCoordinatorType.StackDestination: DestinationType
  
  typealias DummyUsecases<
    DeeplinksCoordinatorType: NavigationCoordinatorType
  > = MainCoordinatorFactoryDelegateTypeMock<
    DeeplinksCoordinatorType,
    DummyCoordinator
  >
  
  typealias Full<
    DeeplinksCoordinatorType: NavigationCoordinatorType,
    UsecasesCoordinatorType: NavigationCoordinatorType & StackCoordinatorType & ModalCoordinatorType
  > = MainCoordinatorFactoryDelegateTypeMock<
    DeeplinksCoordinatorType,
    UsecasesCoordinatorType
  > where UsecasesCoordinatorType.ModalDestination: DestinationType, UsecasesCoordinatorType.StackDestination: DestinationType
  
  @MainActor
  static func create() -> Dummy {
    let factory = Dummy()
    factory.createDeeplinksCoordinatorReturnValue = DummyCoordinator()
    factory.createUsecasesCoordinatorReturnValue = DummyCoordinator()
    return factory
  }
  
  @MainActor
  static func create<
    UsecasesCoordinatorType: NavigationCoordinatorType & StackCoordinatorType & ModalCoordinatorType
  >(
    usecasesCoordinator: UsecasesCoordinatorType
  ) -> DummyDeeplinks<UsecasesCoordinatorType> {
    let factory = DummyDeeplinks<UsecasesCoordinatorType>()
    factory.createDeeplinksCoordinatorReturnValue = DummyCoordinator()
    factory.createUsecasesCoordinatorReturnValue = usecasesCoordinator
    return factory
  }
  
  @MainActor
  static func create<
    DeeplinksCoordinatorType: NavigationCoordinatorType
  >(
    deeplinksCoordinator: DeeplinksCoordinatorType
  ) -> DummyUsecases<DeeplinksCoordinatorType> {
    let factory = DummyUsecases<DeeplinksCoordinatorType>()
    factory.createDeeplinksCoordinatorReturnValue = deeplinksCoordinator
    factory.createUsecasesCoordinatorReturnValue = DummyCoordinator()
    return factory
  }
  
  @MainActor
  static func create<
    DeeplinksCoordinatorType: NavigationCoordinatorType,
    UsecasesCoordinatorType: NavigationCoordinatorType & StackCoordinatorType & ModalCoordinatorType
  >(
    deeplinksCoordinator: DeeplinksCoordinatorType,
    usecasesCoordinator: UsecasesCoordinatorType
  ) -> Full<DeeplinksCoordinatorType, UsecasesCoordinatorType> {
    let factory = Full<DeeplinksCoordinatorType, UsecasesCoordinatorType>()
    factory.createDeeplinksCoordinatorReturnValue = deeplinksCoordinator
    factory.createUsecasesCoordinatorReturnValue = usecasesCoordinator
    return factory
  }
}
