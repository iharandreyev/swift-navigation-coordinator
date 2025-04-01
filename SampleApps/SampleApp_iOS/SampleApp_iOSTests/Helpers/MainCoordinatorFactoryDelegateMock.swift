//
//  MainCoordinatorFactoryDelegateMock.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting
import SwiftUI

@testable
import SampleApp_iOS

#warning("TODO: Implement macro for this")
@MainActor
final class MainCoordinatorFactoryDelegateMock<
  UsecasesCoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType,
  DeeplinksCoordinatorType: ScreenCoordinatorType
>: MainCoordinatorFactoryDelegateType {
  struct Params_createUsecasesCoordinator { }
  
  private let injected_ccreateUsecasesCoordinator: (Params_createUsecasesCoordinator) -> UsecasesCoordinatorType
  private(set) var createUsecasesCoordinator_invocations: [Params_createUsecasesCoordinator] = []
  var createUsecasesCoordinator_count: Int { createUsecasesCoordinator_invocations.count }
  private let createUsecasesCoordinator_invoked: ((Params_createUsecasesCoordinator) -> Void)?
  private var createUsecasesCoordinator_onFinish: (() -> Void)!
  
  func createUsecasesCoordinator() -> UsecasesCoordinatorType {
    let params = Params_createUsecasesCoordinator()
    
    createUsecasesCoordinator_invocations.append(params)
    createUsecasesCoordinator_invoked?(params)
    
    return injected_ccreateUsecasesCoordinator(params)
  }
  
  struct Params_createDeeplinksCoordinator { }
  
  private let injected_createDeeplinksCoordinator: (Params_createDeeplinksCoordinator) -> DeeplinksCoordinatorType
  private(set) var createDeeplinksCoordinator_invocations: [Params_createDeeplinksCoordinator] = []
  var createDeeplinksCoordinator_count: Int { createDeeplinksCoordinator_invocations.count }
  private let createDeeplinksCoordinator_invoked: ((Params_createDeeplinksCoordinator) -> Void)?
  private var createDeeplinksCoordinator_onFinish: (() -> Void)!
  
  func createDeeplinksCoordinator() -> DeeplinksCoordinatorType {
    let params = Params_createDeeplinksCoordinator()
    
    createDeeplinksCoordinator_invocations.append(params)
    createDeeplinksCoordinator_invoked?(params)
    
    return injected_createDeeplinksCoordinator(params)
  }
  
  init(
    createUsecasesCoordinator: @escaping (Params_createUsecasesCoordinator) -> UsecasesCoordinatorType,
    createUsecasesCoordinator_invoked: ((Params_createUsecasesCoordinator) -> Void)? = nil,
    createDeeplinksCoordinator: @escaping (Params_createDeeplinksCoordinator) -> DeeplinksCoordinatorType,
    createDeeplinksCoordinator_invoked: ((Params_createDeeplinksCoordinator) -> Void)? = nil
  ) {
    self.injected_ccreateUsecasesCoordinator = createUsecasesCoordinator
    self.createUsecasesCoordinator_invoked = createUsecasesCoordinator_invoked
    self.injected_createDeeplinksCoordinator = createDeeplinksCoordinator
    self.createDeeplinksCoordinator_invoked = createDeeplinksCoordinator_invoked
  }
}

extension MainCoordinatorFactoryDelegateMock {
  convenience init(
    createUsecasesCoordinator_invoked: ((Params_createUsecasesCoordinator) -> Void)? = nil,
    createDeeplinksCoordinator_invoked: ((Params_createDeeplinksCoordinator) -> Void)? = nil
  ) where UsecasesCoordinatorType == DummyCoordinator, DeeplinksCoordinatorType == DummyCoordinator {
    self.init(
      createUsecasesCoordinator: { _ in DummyCoordinator() },
      createUsecasesCoordinator_invoked: createUsecasesCoordinator_invoked,
      createDeeplinksCoordinator: { _ in DummyCoordinator() },
      createDeeplinksCoordinator_invoked: createDeeplinksCoordinator_invoked
    )
  }
}

typealias MainCoordinatorDelegateMockMinimal = MainCoordinatorFactoryDelegateMock<DummyCoordinator, DummyCoordinator>
